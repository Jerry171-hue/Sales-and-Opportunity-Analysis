# Sales-and-Opportunity-Analysis# Sales Performance & Opportunity Analytics

An end-to-end analysis of a CRM sales pipeline using **MySQL**, **Python (pandas)** and **Power BI**. The project answers: *How is the sales pipeline performing, who and what drives revenue, and where are deals being lost?*

## Dashboard Preview
<img width="1432" height="851" alt="executive_overview_sales" src="https://github.com/user-attachments/assets/e4323890-5e00-4c67-a725-5dc4c1cb1239" />

<img width="1432" height="848" alt="sales_performance" src="https://github.com/user-attachments/assets/1cb98233-750c-407c-93c7-90461d369b1d" />

## Dataset

CRM Sales Opportunities dataset (source: *add link here, e.g. Maven Analytics*), made up of four tables:

| Table | Description |
|---|---|
| `sales_pipeline` | 8,800 opportunities: agent, product, account, deal stage, engage/close dates, close value |
| `accounts` | Customer accounts: sector, year established, revenue, employees, location |
| `products` | Product name, series, sales price |
| `sales_teams` | Sales agents, their managers and regional offices |

Deal stages: **Won** (4,238), **Lost** (2,473), **Engaging** and **Prospecting** (2,089 open deals together).

## Tools Used

- **MySQL**: database design, data cleaning, analysis queries
- **Python** (pandas, matplotlib): exploratory data analysis
- **Power BI**: interactive two-page dashboard

## Project Structure

```
├── data/          # CSV files
├── sql/           # Sales_Product_Analysis.sql
├── notebook/      # Sales_Product_Analysis.ipynb
├── powerbi/       # Sales_Product_Analysis.pbix
├── images/        # Dashboard screenshots
└── README.md
```

## What I Did

### 1. SQL (MySQL)
- Created the database and four tables, and loaded raw data through a staging table, converting empty strings to `NULL` with `NULLIF`.
- Calculated pipeline counts, win/loss rates and average/total deal values by stage.
- Analysed performance by sales agent, manager, product and account.
- Used **CTEs**, **subqueries**, **CASE WHEN** aggregation, **JOINs** and **window functions** (`RANK`, `DENSE_RANK`, `PARTITION BY`) to rank agents overall and within each region.

### 2. Python (Jupyter)
- Checked shape, data types, missing values and duplicate opportunity IDs.
- Explored deal stage mix, deal value distribution, agent and product performance.
- Created a month column and calculated the **sales cycle length** (engage date to close date).
- Visualised stage distribution, deal values, opportunities by product and opportunities over time.

### 3. Power BI
- **Executive Overview:** KPI cards (total, won, lost and open deals, win rate, revenue), opportunities by stage, revenue trend, revenue by product and by agent, with slicers for product, deal stage, region and sector.
- **Sales Performance:** detailed tables for agent, manager, region and product with conditional formatting.

## Key Findings

- **8,800** opportunities: **4,238 won**, **2,473 lost**, **2,089 still open**.
- Closed-deal win rate is **63.2%** (Won ÷ (Won + Lost)). Counting open deals in the denominator gives 48.2%.
- Won deals generated about **10.0M** in revenue, roughly **2,361 per won deal**.
- **Three products drive about 84% of revenue:** GTXPro, GTX Plus Pro and MG Advanced.
- **Darcel Schlecht** is the top agent, with about 11.5% of total revenue, far ahead of the next agent.
- **West** is the top region by revenue; **Central** handles the most opportunities but ranks second in revenue.
- Closed deals took about **48 days** on average to close (median 45).

## Business Recommendations

- Focus sales effort on the top three products, and review pricing and positioning of low-revenue products such as MG Special and GTK 500.
- Study the practices of top agents and share them with lower performers.
- Review the pipeline of open deals to speed up conversion, since over 2,000 opportunities are still unresolved.

## How to Run

1. Clone the repository.
2. **SQL:** run `sql/Sales_Product_Analysis.sql` in MySQL, then import the CSVs from `data/`.
3. **Notebook:** `pip install pandas matplotlib jupyter`, then open the notebook (file paths are relative to `data/`).
4. **Power BI:** open the `.pbix` file in Power BI Desktop.

## Author

**Jerry A. Yonith Spenser**
[LinkedIn](https://linkedin.com/in/jerry-a-yonith-spenser) | [GitHub](https://github.com/Jerry171-hue) | yonithj@gmail.com
