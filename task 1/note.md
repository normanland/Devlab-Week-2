# Sales and Profit Analysis Across Regions and Categories

## Project note

This was my first SQL-focused task in the programme, so I kept the analysis inside MySQL instead of reading the full CSV into pandas.

I first created a local `store_db` database and defined the `orders` table manually with the required data types. The Superstore CSV was then imported with `load data local infile`, converting the two date fields during the import. After checking the table structure and row count, I wrote the analysis in a separate SQL file and later connected the same MySQL database to Jupyter with SQLAlchemy.

The notebook only reads SQL results with `pd.read_sql()` and uses them for visualization. Aggregation, ranking, discount bucketing, CTEs and year-over-year calculations all stay in SQL.

A few initial checks were useful before moving into the business questions:

- 9,994 rows
- 793 unique customers
- 1,862 unique products
- order history from 2014-01-03 to 2017-12-30
- no null values
- 8 repeated `order_id + product_id` combinations, each appearing twice

## Table structure

```sql
create table orders (
    row_id int primary key,
    order_id varchar(20),
    order_date date,
    ship_date date,
    ship_mode varchar(30),
    customer_id varchar(20),
    customer_name varchar(100),
    segment varchar(30),
    country varchar(50),
    city varchar(100),
    state varchar(100),
    postal_code int,
    region varchar(30),
    product_id varchar(30),
    category varchar(50),
    sub_category varchar(50),
    product_name varchar(300),
    sales decimal(12, 4),
    quantity int,
    discount decimal(6, 4),
    profit decimal(12, 4)
);
```

## Business insights

### 1. The main discount problem starts above 20%

Q7 shows a clear shift once discounts move beyond 20%. Orders with no discount generated **320,987.60** in total profit, while the **41%+** band produced **-99,558.59** total profit and **-106.71** average profit.

The additional sub-category check makes this more specific: above 20% discount, **Binders** had the largest total loss at **-38,510.50**, while **Machines** had the lowest average profit at **-557.65**.

This suggests that discount limits should be reviewed first in the sub-categories where high discounts are already producing the largest losses, rather than applying the same discount policy everywhere.

### 2. Tables are a serious profit issue, but the problem is regional

Q5 shows that Tables were loss-making in the **East, South and Central** regions. The East was the weakest, with **-11,025.38** profit and a **-28.17%** margin. In contrast, the West still produced **1,482.61** profit from Tables.

Q9 also shows that Tables were the largest loss-making sub-category overall at **-17,725.48**, despite representing **9.01% of total sales**.

Because the same sub-category performs differently by region, the better action is to investigate regional pricing and discount behaviour instead of treating Tables as equally unprofitable everywhere.

### 3. Strong sales do not always mean strong business performance

Q6 places **Copiers** at the top with **55,617.82** total profit, while **Tables** sit at the bottom with **-17,725.48**.

This gap is important because Tables still contribute a meaningful share of company revenue. Looking only at sales would hide that weakness. Product performance should therefore be evaluated with profit and margin alongside revenue, especially for high-volume sub-categories.

### 4. Sales recovered strongly after 2015, but growth quality matters

Q8 shows a **2.83% decline in 2015**, followed by a **29.47% increase in 2016** and another **20.36% increase in 2017**.

The later years show strong sales momentum, but Q7 and Q9 also show that some of that revenue comes from heavily discounted or loss-making areas. Future growth should therefore be tracked together with profitability, not only total sales.

## Final note

The strongest pattern in this analysis is not a lack of sales. The more important issue is where revenue is being converted into weak or negative profit. High discount levels and region-specific losses in a few sub-categories are the clearest areas for improvement.

The SQL file contains the full set of queries, while the Jupyter notebook is used only to display query results and build the visualizations.
