# supply-chain-analytics
End-to-end data analytics for North America Retail Supply Chain | Power BI · SQL · Excel · Tableau
# 🏪 North America Retail Supply Chain & Sales Analytics

**Tools:** Power BI (DAX · Power Query) · SQL Server (T-SQL) · Excel · Tableau · Google Sheets  
**Period:** 2014 – 2017 | **Orders:** 5,000+ | **States:** 49

---

## 📌 Problem
A US retail supply chain facing:
- High delivery delays impacting customer satisfaction
- Increasing return rates with no clear root cause
- Pricing inefficiencies across regions
- No unified visibility on logistics cost and profitability

---

## 🔧 What I Did

### Data Pipeline (ETL)
- Extracted raw data from Excel and loaded into SQL Server
- Cleaned data using Power Query: removed nulls, standardized dates, fixed inconsistent product names
- Created calculated fields: Delivery Days, Profit per Unit, Return Flag

### Data Modeling
- Designed a **Star Schema** relational database with Fact and Dimension tables
- Tables: `Fact_Retails`, `DIM_Product`, `DIM_Customer`, `DIM_Region`, `DIM_Shipping`, `Calendar_Table`, `State_Coords`

### SQL Analysis
- Wrote analytical views, joins across multiple tables, aggregation functions
- Created indexes for query optimization
- Built stored procedures for recurring reporting queries

### Power BI Dashboard (8 Pages)
- **Overview:** Total Sales $2.30M · Total Profit $286.40K · 793 Customers
- **Executive Analysis:** Profit Margin 12.47% · Avg Delivery Days 34.61 · Total Orders 5,009
- **Regional Analysis:** Category sales, ship mode breakdown, top cities by revenue
- **Lead Time Analysis:** Shipping mode comparison, delivery trends over time
- **Geographic Analysis:** Business overview by region, orders by lat/long
- **Profitability Analysis:** Profit by category, sales growth for top sub-categories

---

## 📊 Key Findings
- **Standard Class** shipping averaged **41.8 days** — highest delay across all ship modes
- **West region** leads in sales ($725K) but also has the highest return count (490)
- **Consumer segment** drives 50.56% of total sales volume
- **Office Supplies** is the top-selling category across all regions
- Discounts in some regions increased order volume but reduced net profit

---

## ✅ KPIs Tracked
`Return Rate` · `On-Time Delivery %` · `Avg Delivery Days` · `Lost Profit` · `Profit Margin` · `Late Shipment Rate`

---

## 📁 Files in This Repository
| File | Description |
|------|-------------|
| `Supply_Chain_Dashboard.pbix` | Power BI dashboard — all 8 pages |
| `north-america-retail-supply-chain-sales-analysis.xlsx` | Raw data + cleaned dataset + pivot analysis |
| `Supply_Chain_Queries.docx` | SQL queries used for data modeling and analysis |
