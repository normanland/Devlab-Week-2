-- q1: a profile of the orders table

select
    count(*) as total_rows,
    count(distinct customer_id) as unique_customers,
    count(distinct product_id) as unique_products,
    min(order_date) as first_order_date,
    max(order_date) as latest_order_date
from orders;

-- output: 9,994 rows, 793 customers and 1,862 products;  
-- covering orders from 2014-01-03 to 2017-12-30.

-- q2: checking null values across all columns

select
    count(*) - count(row_id) as row_id_nulls,
    count(*) - count(order_id) as order_id_nulls,
    count(*) - count(order_date) as order_date_nulls,
    count(*) - count(ship_date) as ship_date_nulls,
    count(*) - count(ship_mode) as ship_mode_nulls,
    count(*) - count(customer_id) as customer_id_nulls,
    count(*) - count(customer_name) as customer_name_nulls,
    count(*) - count(segment) as segment_nulls,
    count(*) - count(country) as country_nulls,
    count(*) - count(city) as city_nulls,
    count(*) - count(state) as state_nulls,
    count(*) - count(postal_code) as postal_code_nulls,
    count(*) - count(region) as region_nulls,
    count(*) - count(product_id) as product_id_nulls,
    count(*) - count(category) as category_nulls,
    count(*) - count(sub_category) as sub_category_nulls,
    count(*) - count(product_name) as product_name_nulls,
    count(*) - count(sales) as sales_nulls,
    count(*) - count(quantity) as quantity_nulls,
    count(*) - count(discount) as discount_nulls,
    count(*) - count(profit) as profit_nulls
from orders;

-- output: no null values were found.

-- q3: checking duplicate order lines

select order_id, product_id, count(*) as duplicate_count
from orders
group by order_id, product_id
having count(*) > 1
order by duplicate_count desc;

-- output: 8 order-product combinations were duplicated, with each pair appearing twice in the dataset.

-- q4: average shipping time by ship mode

select ship_mode,
    round(avg(datediff(ship_date, order_date)), 2) as avg_days_to_ship
from orders
group by ship_mode
order by avg_days_to_ship;

-- output: standard class averaged 5.01 days, compared with 2.18 days for first class 
-- and 0.04 days for same day.

-- q5: comparing profit across regions and product groups

select region, category, sub_category,
    round(sum(sales), 2) as total_sales,
    round(sum(profit), 2) as total_profit,
    round(sum(profit) / sum(sales) * 100, 2) as profit_margin
from orders
group by region, category, sub_category
order by total_profit;

-- output: tables were loss-making in the east, south and central, with the east showing the largest loss at -11,025.38 and a -28.17% margin. 
-- In the west, tables still made a small profit of 1,482.61.

-- q6: comparing the most and least profitable sub-categories

select 'top 5' as profit_group, sub_category, total_profit
from (
    select
        sub_category,
        round(sum(profit), 2) as total_profit
    from orders
    group by sub_category
    order by total_profit desc
    limit 5
) as top_categories
union all
select 'bottom 5' as profit_group, sub_category, total_profit
from (
    select
        sub_category,
        round(sum(profit), 2) as total_profit
    from orders
    group by sub_category
    order by total_profit
    limit 5
) as bottom_categories;

-- output: copiers had the highest total profit at 55,617.82, while tables had the lowest at -17,725.48.

-- q7: checking profit across different discount levels

select
    case
        when discount = 0 then '0%'
        when discount <= 0.20 then '1-20%'
        when discount <= 0.40 then '21-40%'
        else '41%+'
    end as discount_band,
    count(distinct order_id) as order_count,
    round(avg(profit), 2) as avg_profit,
    round(sum(profit), 2) as total_profit
from orders
group by discount_band
order by
    case discount_band
        when '0%' then 1
        when '1-20%' then 2
        when '21-40%' then 3
        else 4
    end;
    
-- output: orders with no discount generated 320,987.60 total profit, 
-- while the 41%+ discount band lost 99,558.59 with an average profit of -106.71.

-- q8: yearly sales growth

with yearly_sales as (
    select year(order_date) as order_year,
        round(sum(sales), 2) as total_sales
    from orders
    group by year(order_date)
)

select order_year, total_sales,
    lag(total_sales) over (order by order_year) as previous_year_sales,
    round(
        total_sales - lag(total_sales) over (order by order_year), 2
    ) as sales_change,
    round(
        (total_sales - lag(total_sales) over (order by order_year))
        / lag(total_sales) over (order by order_year) * 100, 2
) as yoy_change_pct
from yearly_sales
order by order_year;

-- output: sales fell slightly by 2.83% in 2015, then increased by 29.47% in 2016 and 20.36% in 2017.

-- q9: sub-categories with negative total profit, and the share of total revenue they represent

with subcategory_profit as (
    select
        sub_category,
        sum(sales) as total_sales,
        sum(profit) as total_profit
    from orders
    group by sub_category
),

overall_sales as (
    select sum(sales) as total_sales
    from orders
)

select
    s.sub_category,
    round(s.total_sales, 2) as total_sales,
    round(s.total_profit, 2) as total_profit,
    round(s.total_sales / o.total_sales * 100, 2) as revenue_share_pct
from subcategory_profit s
cross join overall_sales o
where s.total_profit < 0
order by s.total_profit;

-- output: tables, bookcases and supplies were the only loss-making sub-categories. 
-- tables had the largest loss at -17,725.48 and still represented 9.01% of total sales.

-- q10: the most profitable customers

select
    customer_id,
    customer_name,
    count(distinct order_id) as order_count,
    round(sum(sales), 2) as lifetime_sales,
    round(sum(profit), 2) as lifetime_profit,
    round(sum(sales) / count(distinct order_id), 2) as avg_order_value
from orders
group by customer_id, customer_name
order by lifetime_profit desc
limit 10;

-- output: Tamara Chand generated the highest lifetime profit at 8,981.32 from 5 orders, 
-- with an average order value of 3,810.44.

-- addition: checking which sub-categories lose the most under higher discounts

select
    sub_category,
    round(sum(case when discount <= 0.20 then profit else 0 end), 2) as profit_up_to_20,
    round(sum(case when discount > 0.20 then profit else 0 end), 2) as profit_above_20,
    round(avg(case when discount > 0.20 then profit end), 2) as avg_profit_above_20,
    sum(case when discount > 0.20 then 1 else 0 end) as high_discount_lines
from orders
group by sub_category
having high_discount_lines > 0
order by profit_above_20;

-- output: discounts above 20% hurt binders, tables and machines the most, 
-- while copiers remained profitable even at higher discount levels.
