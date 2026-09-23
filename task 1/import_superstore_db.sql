create database store_db;

use store_db;

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

describe orders;

select count(*) as total_rows
from orders;

-- checking local file import setting

show global variables like 'local_infile';

-- local csv import
set global local_infile = 1;

show global variables like 'local_infile';

load data local infile 'C:/Users/anarrasulzada/Desktop/Sample - Superstore.csv'
into table orders
character set latin1
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(
    row_id,
    order_id,
    @order_date,
    @ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    @postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit
)
set
    order_date = str_to_date(@order_date, '%m/%d/%Y'),
    ship_date = str_to_date(@ship_date, '%m/%d/%Y'),
    postal_code = nullif(@postal_code, '');
    
    -- checking the imported row count

select count(*) as total_rows
from orders;

select * from orders
limit 5;
