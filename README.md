# BharatKart Sales Analytics

## 📌 Project Overview

BharatKart Sales Analytics is an end-to-end e-commerce analytics project built using **Python, Pandas, SQL, and Power BI** to analyze customers, orders, products, sellers, payments, and returns for an Indian e-commerce marketplace.

The project follows a complete analytics lifecycle — from raw data exploration and cleaning, through SQL-based business analysis and diagnostic (root-cause) analysis, to a fully interactive Power BI dashboard with relational data modeling.

**Repository:** [BharatKart-Sales-Analytics](https://github.com/krishna-srivastava/BharatKart-Sales-Analytics)

---

## 🎯 Business Problem

BharatKart's raw sales data showed a business that looked healthy on the surface but had underlying issues that needed investigation:

- Revenue was strong, but overall profit margin was unusually thin.
- Revenue peaked during the Q4/October festive season, yet profitability dropped sharply in the same period.
- Most customers placed only one order, and the highest-spending (VIP) customer segment carried the lowest profit margin.
- A large share of orders were delivered later than their expected delivery date.
- Certain seller states and tiers showed disproportionate losses relative to their revenue.

This project investigates these problems end-to-end — from raw data to a diagnostic root-cause analysis to a business-ready Power BI dashboard.

---

## 🎯 Project Objectives

- Explore and clean raw e-commerce data across 7 relational tables
- Validate table relationships and data consistency before analysis
- Answer business questions using SQL across sales, customers, products, sellers, payments, and returns
- Perform diagnostic (root-cause) analysis on key business problems
- Build a relational data model in Power BI with a dedicated Calendar table
- Design a multi-page Power BI dashboard covering the full business
- Summarize findings into clear, evidence-based business insights

---

## 🗂️ Dataset / Tables

| Table | Description | Approx. Size |
|---|---|---|
| `customers` | Customer information | ~40K customers |
| `sellers` | Marketplace seller information | ~1.2K sellers |
| `products` | Product / SKU information | ~3.5K products |
| `orders` | Order-level information | ~100K+ orders |
| `order_items` | Individual items within each order (product, seller, quantity, pricing, profit) | — |
| `payments` | Payment information (one payment per order) | — |
| `returns` | Return information (supports whole-order and partial line-item returns) | — |
| `Calendar` | Standalone Power BI date table for time intelligence | — |

### 🔗 Data Relationships

- `customers` **1 → many** `orders`
- `sellers` **1 → many** `products`
- `sellers` **1 → many** `order_items`
- `products` **1 → many** `order_items`
- `orders` **1 → many** `order_items`
- `orders` **1 → 1** `payments`
- `orders` **1 → many** `returns`
- `order_items` **1 → many** `returns`

The Power BI data model follows a relational (star-like) design, with a dedicated Calendar table enabling time-intelligence calculations across the dashboard.

---

## 🛠️ Tools & Technologies

- **Python / Pandas** — data exploration, cleaning, and feature engineering
- **SQL** — business-question-driven querying and diagnostic (root-cause) analysis across all tables
- **Power BI / DAX** — data modeling, KPI calculation, and dashboard development
- **GitHub** — version control and project documentation

---

## 🔄 Project Workflow

Raw Data → Exploration & Cleaning → SQL Analysis → Diagnostic Analysis
→ Relationship Validation → Power BI Data Modeling → Power BI Dashboard

### 1. Data Exploration & Cleaning
Each table was explored individually in Python/Pandas — inspecting structure, data types, missing values, duplicates, and inconsistent text/categorical values — followed by targeted cleaning and standardization for each table.

### 2. SQL Analysis
A dedicated SQL query folder covering business questions across sales, customers, products, sellers, orders, payments, and returns — including aggregation, ranking, and segment-level breakdowns.

### 3. Diagnostic Analysis
A structured, hypothesis-driven SQL investigation into the key business problems identified above (profitability, seasonal profit collapse, customer behavior, delivery delays, and seller/state-level losses) — comparing relevant dimensions (discount depth, base margin, category mix, geography, time period) to isolate likely drivers rather than relying on surface-level metrics alone.

### 4. Relationship Validation
Verification of primary/foreign key integrity and table relationships across all 7 tables to ensure the data model is consistent before it was loaded into Power BI.

### 5. Power BI Dashboard
A relational data model with a Calendar table, DAX measures, and a 7-page interactive dashboard covering the business end-to-end.

---

## 🐍 Python / Pandas Analysis

The Python/Pandas layer of the project covers:

- Data inspection and exploration
- Missing-value analysis and duplicate detection
- Data type checking and correction
- Data cleaning and text standardization
- Categorical, product, category, and sub-category analysis
- Customer segmentation and feature engineering (delivery days, delivery delay, profit)
- Aggregations, GroupBy analysis, and dataset merging

---

## 🗄️ SQL Analysis

All SQL queries are organized in the `SQL query/` folder and are used to answer business questions across:

- Sales analysis
- Customer analysis
- Product analysis
- Seller analysis
- Order analysis
- Profitability analysis
- Payment analysis
- Return analysis
- Aggregation and ranking-based business questions

## 🔬 Diagnostic (Root-Cause) Analysis

A separate, SQL-driven diagnostic phase investigated five key business problems in depth — testing hypotheses (e.g., discount depth vs. base margin, October vs. rest-of-year, one-time vs. repeat customers, state/seller/category delivery performance) through targeted comparison queries rather than broad exploration. Findings and recommendations from this phase are documented in the `Report/` folder.

---

## 📊 Power BI Dashboard

The dashboard consists of **7 pages**, each focused on a specific area of the business.

### 1. Executive Overview
High-level business overview of sales, profitability, orders, customers, and products.

- **KPIs:** Net Sales · Net Profit · Total Orders · Profit Margin · Average Order Value
- **Visuals:** Revenue Trend Over Time · Category-wise Performance · Top 10 Sales by State · Net Sales by Customer Segment · Top 10 Products by Sales
- **Filters:** Year · Month · State · Category · Order Status

### 2. Sales & Orders
- **KPIs:** Net Sales · Net Profit · Total Items · Total Quantity Sold · Average Order Value · Average Items per Order
- **Visuals:** Monthly Net Sales Trend · Monthly Order Volume · Net Sales Distribution by Day of Week · Order Status Distribution · Order Volume by Basket Size

### 3. Customer Analytics
- **KPIs:** New Customers (24K) · Repeat Customers (15K) · VIP Customers (381) · Average Customer Spend (27.75K) · Average Orders per Customer (2.59)
- **Visuals:** Monthly Customer Growth Trend · Top 10 Customers by Spend · Customer Distribution by State · Net Sales by Customer Segment · Average Spend by Customer Segment

### 4. Product Analytics
- **KPIs:** Total Products (3.5K) · Net Sales (870.91M) · Profit Margin (2.38%) · Average Unit/Product (62.80) · Average Cost Price (3.63K) · Average Selling Price (4.59K)
- **Visuals:** Category-wise Performance · Sub-category-wise Performance · Top 10 Products by Profit · Top 10 Loss-Making Products · Top 10 Products by Quantity Sold
- **Filters:** Year · Month · Category · Sub Category · Order Status

### 5. Seller Analytics
- **KPIs:** Total Active Sellers (1,064) · Net Sales (870.91M) · Net Profit (20.70M) · Average Revenue per Seller (818.62K) · Average Orders per Seller (76.24)
- **Visuals:** Top 10 Sellers by Revenue · Top 10 Profit-Making Sellers · Top 10 Loss-Making Sellers · Top 10 Seller States by Sales · Sales by Seller Tier · Sales by Seller Rating

### 6. Delivery & Operations
- **KPIs:** Total Delivered Orders (87.74K) · On-Time Orders (34.05K) · Delayed Orders (53.69K) · Average Delivery Days (5.02) · Average Delivery Delay (1.26)
- **Visuals:** Monthly Delivery Performance · Expected vs Actual Delivery Days · Top Reasons for Order Cancellation · On-Time vs Delayed Delivery Share · Top 10 Cities by Delivery Delay

### 7. Payments & Returns
- **KPIs:** Total Payments · Successful Payments · Failed Payments · Total Refund Amount · Return Rate
- **Visuals:** Monthly Payment Amount Trend · Payment Method Distribution · Payment Status Distribution · Top Return Reasons · Monthly Return Trend

---

## 🔍 Key Insights

- Overall profit margin remains thin relative to total revenue, driven largely by a mismatch between discount levels and category-level base margins rather than by unprofitable products themselves.
- **Electronics** and **Grocery** show negative overall profit margins — both are inherently thin-margin categories where standard promotional discounting is enough to push a large share of transactions into a loss.
- The **October/Q4 festive period** generates the highest revenue of the year but also the sharpest profitability decline, driven by a near-universal discount spike across almost every product category.
- **VIP customers** generate the highest average order value but carry the **lowest profit margin** of all customer segments — this traces back to their spending being heavily concentrated in Electronics, not to VIP-specific discounting.
- The majority of customers place only one order; customers acquired during the October festive period show a noticeably lower repeat-purchase rate than customers acquired in other months.
- A majority of orders are delivered later than their expected delivery date, but the delay pattern is distributed fairly evenly across states, sellers, and categories — pointing to a systemic delivery-estimation issue rather than a localized operational failure.
- Certain seller states and lower-performing sellers contribute a disproportionate share of losses relative to their revenue, concentrated in the same low-margin categories identified above.

---

## 📁 Repository Structure

```
BharatKart-Sales-Analytics/
│
├── Raw Data/                  # Original, unprocessed source data
├── Exploration n Cleaning/    # Python/Pandas notebooks - data exploration & cleaning
├── SQL query/                 # SQL scripts for business-question analysis
├── Diagnostic Analysis/       # SQL-based root-cause analysis scripts for key business problems
├── Relationship Validation/   # Table relationship & data integrity checks
├── Clean Data/                # Final cleaned datasets used for analysis
├── Report/                    # Written analysis and diagnostic reports
├── PowerBi Dashboard/         # Power BI file, data model, and dashboard screenshots
│   ├── Dashboard Screenshot/  # Page-by-page dashboard screenshots
│   ├── BharatKart_Dashboard.pbix
│   └── Data model_ss.png
└── README.md
```

---

## 🚀 How to Use This Repository

1. **Explore the analysis process** — start with `Raw Data/`, then follow `Exploration n Cleaning/` → `SQL query/` → `Diagnostic Analysis/` → `Relationship Validation/` → `Clean Data/` to see how the data was processed.
2. **Review the SQL analysis** — open the `.sql` files inside `SQL query/` to see the business questions answered at the database level, and the diagnostic queries inside `Diagnostic Analysis/` to see the root-cause investigation.
3. **Read the findings** — check the `Report/` folder for the full written analysis and diagnostic conclusions.
4. **View the dashboard** — open `PowerBi Dashboard/BharatKart_Dashboard.pbix` in **Power BI Desktop** to explore the interactive dashboard, or view the page-by-page screenshots in `Dashboard Screenshot/` for a quick preview without opening Power BI.

---

## 👤 Author

**Krishna Srivastava**

- GitHub: [krishna-srivastava](https://github.com/krishna-srivastava)
- LinkedIn: [krishna-srivastava](https://www.linkedin.com/in/krishna-srivastava-b402a1323/)
