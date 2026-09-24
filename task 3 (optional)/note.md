# Revenue Analysis and Customer-Level Aggregation on UK E-Commerce Data

## Methodology

I worked with the UK Online Retail dataset containing 541,909 transaction rows and 8 columns. Before calculating revenue, I separated the records that could distort the main sales analysis instead of removing everything at once.

`CustomerID` was missing in 135,080 rows, so those records were excluded from customer-level calculations. Cancelled invoices were identified from `InvoiceNo` values starting with `C`, while negative quantities were kept separately for return analysis. The cleaned sales table then kept known customers, non-cancelled invoices and positive quantities.

Revenue was calculated as:

`Revenue = Quantity × UnitPrice`

From there, I looked at the data from several levels rather than treating it as one sales table. Customer-level aggregation was used for revenue, order frequency and average order value; country-level aggregation was used for market contribution; invoice-level data was used for cancellation rates and basket size; and monthly aggregation was used to see the sales pattern over time.

The final cleaned sales table contains 397,924 rows and 4,339 identified customers. Cancellation rate was calculated from unique invoices rather than transaction rows, because one invoice can contain many products and counting rows would overstate the result.

## What stood out from the analysis

### 1. Revenue is heavily concentrated in the UK

The United Kingdom generated about **£7.31M**, equal to roughly **82.0% of cleaned revenue**. The next markets were much smaller: the Netherlands contributed about **£285K (3.2%)**, EIRE about **£266K (3.0%)**, Germany **£229K (2.6%)**, and France **£209K (2.3%)**.

The main point for me is not simply that the UK is first, but how large the gap is. International sales are present, but the business is still highly dependent on one market.

### 2. The strongest revenue period appears just before the end of the year

Monthly revenue reached its highest level in **November 2011 at about £1.16M**. October was also above **£1.03M**, while September reached around **£953K**.

This creates a clear late-year build-up rather than an isolated one-month spike. For inventory and campaign planning, September to November looks like the period where demand becomes especially important.

### 3. A small group of customers contributes a noticeable share of revenue

The highest-revenue customer generated about **£280K**, followed by customers with approximately **£260K** and **£195K**. The **top 5 customers account for about 11.7% of total cleaned revenue**, while the top 10 account for roughly **17.3%**.

There is also an interesting difference between frequent and high-value buyers. For example, some leading customers generated their revenue across dozens or even hundreds of orders, while others reached a very high total with only one or two large purchases. That is why I would not treat all top customers as the same type of customer.

### 4. Product volume is more concentrated than the raw product names initially suggest

The highest quantity in the cleaned data came from **PAPER CRAFT , LITTLE BIRDIE** with **80,995 units**, followed by **MEDIUM CERAMIC TOP STORAGE JAR** with **77,916 units**. Other high-volume products include **WORLD WAR 2 GLIDERS ASSTD DESIGNS** and **JUMBO BAG RED RETROSPOT**.

This ranking is useful for stock planning, but quantity alone should not be interpreted as product profitability. A product can move a large number of units without necessarily contributing the same amount of revenue as a higher-priced item.

### 5. Cancellation behaviour differs noticeably between markets

Across all unique invoices, the overall cancellation rate was about **14.8%**. The UK was slightly below that benchmark at around **14.4%**, while several markets were above it. Germany was around **24.2%**, EIRE **20.0%**, Switzerland **27.0%**, and Japan **32.1%**.

These percentages need some context. Markets such as Japan have a much smaller number of invoices, so a few cancellations can move the rate sharply. Germany and EIRE are more useful signals because they combine an elevated cancellation rate with a larger order base. I would investigate those markets before treating every high percentage as equally important.

## Additional observations

The basket-size analysis also showed that some smaller markets have relatively large baskets when measured by unique products per invoice. This is useful as a behavioural signal, but I would keep it separate from revenue performance because a larger basket does not automatically mean a more valuable order.

The notebook also includes a monthly spending view for the top 10 customers, which makes it easier to see whether their value comes from steady purchasing or a few unusually large months.

## Final note

The analysis is based on cleaned positive sales for revenue-related metrics, while cancellations and negative quantities were kept separately for return analysis. This separation matters because mixing purchases and returns in the same aggregation would make revenue, product demand and customer value harder to interpret.
