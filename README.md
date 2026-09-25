# BharatKart Sales Analytics

> End-to-end e-commerce sales analytics project using Python, Pandas,
> SQL, Excel, Jupyter Notebook, and Power BI.

![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=for-the-badge\&logo=python\&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-150458?style=for-the-badge\&logo=pandas\&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Analytics-4479A1?style=for-the-badge)
![Power
BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge\&logo=powerbi\&logoColor=black)

---

## 📌 Executive Summary {#pushpin-executive-summary}

**BharatKart Sales Analytics** is an end-to-end e-commerce analytics
project built around an Indian online marketplace.

The project analyzes **customers, orders, order items, products,
sellers, payments, and returns** to understand sales performance,
profitability, customer behavior, seller performance, delivery
operations, and payment/return activity.

### 🎯 Goals {#dart-goals}

* Analyze sales and revenue trends.
* Understand customer segments and purchasing behavior.
* Identify high-performing and loss-making products.
* Evaluate seller revenue and profitability.
* Analyze delivery performance and delays.
* Study payment and return patterns.
* Build a relational Power BI data model.
* Convert analytical findings into interactive business dashboards.

---

## 🛠️ Tech Stack {#hammer_and_wrench-tech-stack}

Tool                   Purpose

---

**Python**             Data exploration, cleaning, preprocessing, and analysis
**Pandas**             Data manipulation and transformation
**Jupyter Notebook**   Interactive analysis
**SQL**                Joins, aggregations, business logic, and analytical queries
**Power BI**           Data modeling, DAX, KPIs, and dashboards
**Excel**              Supporting data inspection and analysis
**DAX**                Measures and business calculations

---

## 🏗️ Data Architecture & Workflow {#building_construction-data-architecture--workflow}

```text
Raw Data
   ↓
Exploration & Cleaning
   ↓
Clean Data
   ↓
Diagnostic Analysis
   ↓
Relationship Validation
   ↓
SQL Analysis
   ↓
Power BI Data Model + DAX
   ↓
Interactive Business Dashboard
   ↓
Business Report
```

### Core entities

```text
Customers ─────► Orders ─────► Order Items ◄──── Products ◄──── Sellers
                    │               │
                    ├────► Payments │
                    │               └────► Returns
                    └────► Returns

                    Calendar
                       │
                       └──── Date-based analysis
```

---

## 📂 Repository Structure {#open_file_folder-repository-structure}

```text
BharatKart-Sales-Analytics/
│
├── Raw Data/
│   └── Unprocessed e-commerce datasets
│
├── Exploration n Cleaning/
│   └── EDA, data cleaning, preprocessing, and quality checks
│
├── Clean Data/
│   └── Cleaned datasets ready for analysis and modeling
│
├── Diagnostic Analysis/
│   └── Advanced analytical scripts and diagnostic notebooks
│
├── Relationship validation/
│   └── Data model and relationship validation
│
├── SQL query/
│   └── SQL business questions, joins, aggregations, and analysis
│
├── PowerBi Dashboard/
│   └── Power BI .pbix files, dashboards, and visual layouts
│
├── Report/
│   └── Detailed business reports and executive summaries
│
└── README.md
```

---

# 📊 Key Analytics {#bar_chart-key-analytics}

## 💰 Sales & Revenue {#moneybag-sales--revenue}

* Monthly sales and revenue trends
* Monthly order volume
* Category-wise performance
* State-wise sales
* Quantity sold
* Average Order Value
* Profit and profit margin
* Basket-size analysis

## 👥 Customer Analytics {#busts_in_silhouette-customer-analytics}

* New, Repeat, and VIP customers
* Customer growth
* Customer spend
* Average orders per customer
* Customer distribution by state
* Revenue by customer segment
* Top customers by spend
* Average spend by segment

## 📦 Product Analytics {#package-product-analytics}

* Category and sub-category performance
* Top products by sales
* Top products by profit
* Loss-making products
* Quantity sold by product
* Average cost price
* Average selling price
* Product profitability

## 🏪 Seller Analytics {#convenience_store-seller-analytics}

* Active sellers
* Seller revenue and profit
* Average revenue per seller
* Average orders per seller
* Top sellers by revenue
* Top profit-making sellers
* Loss-making sellers
* Seller performance by state
* Sales by seller tier and rating

## 🚚 Delivery & Operations {#truck-delivery--operations}

* Delivered orders
* On-time vs delayed orders
* Average delivery days
* Average delivery delay
* Monthly delivery performance
* Expected vs actual delivery days
* Delivery delay by city
* Order cancellation reasons

## 💳 Payments & Returns {#credit_card-payments--returns}

* Payment method analysis
* Payment status
* Payment amount trends
* Return activity
* Refund amounts
* Return reasons
* Return status
* Payment and post-order activity

---

# 📈 Power BI Dashboard {#chart_with_upwards_trend-power-bi-dashboard}

The report contains **7 analytical pages**:

Page                           Focus

---

🏠 **Executive Overview**      Overall business KPIs, revenue, profit, categories, states, customers, and products
📊 **Sales & Orders**          Sales trends, order volume, quantity, basket size, and order status
👥 **Customer Analytics**      Customer growth, segmentation, spend, and retention-oriented analysis
📦 **Product Analytics**       Categories, products, profitability, pricing, and quantity
🏪 **Seller Analytics**        Seller revenue, profit, rankings, states, tiers, and ratings
🚚 **Delivery & Operations**   Delivery performance, delays, cancellations, and operational trends
💳 **Payments & Returns**      Payment behavior, returns, refunds, and post-order activity

---

## 🖼️ Dashboard Screenshots {#framed_picture-dashboard-screenshots}

Add screenshots to your repository and update these paths as needed:

```markdown
![Executive Overview](PowerBi%20Dashboard/screenshots/executive-overview.png)

![Sales & Orders](PowerBi%20Dashboard/screenshots/sales-orders.png)

![Customer Analytics](PowerBi%20Dashboard/screenshots/customer-analytics.png)

![Product Analytics](PowerBi%20Dashboard/screenshots/product-analytics.png)

![Seller Analytics](PowerBi%20Dashboard/screenshots/seller-analytics.png)

![Delivery & Operations](PowerBi%20Dashboard/screenshots/delivery-operations.png)

![Payments & Returns](PowerBi%20Dashboard/screenshots/payments-returns.png)
```

---

# 🔄 How to Replicate {#arrows_counterclockwise-how-to-replicate}

## 1. Clone the repository {#1-clone-the-repository}

```bash
git clone https://github.com/krishna-srivastava/BharatKart-Sales-Analytics.git
cd BharatKart-Sales-Analytics
```

> Replace the URL above if your repository is moved or renamed.

## 2. Set up Python {#2-set-up-python}

```bash
python -m venv venv
```

Windows:

```bash
venv\Scriptsctivate
```

Install the analysis libraries:

```bash
pip install pandas numpy matplotlib seaborn jupyter openpyxl
```

## 3. Run the notebooks {#3-run-the-notebooks}

Start Jupyter:

```bash
jupyter notebook
```

Then work through:

```text
Exploration n Cleaning/
Diagnostic Analysis/
Relationship validation/
```

## 4. Run the SQL analysis {#4-run-the-sql-analysis}

Open the scripts in:

```text
SQL query/
```

Run them in your preferred SQL environment against the appropriate
cleaned data.

## 5. Open the Power BI report {#5-open-the-power-bi-report}

Open the `.pbix` file inside:

```text
PowerBi Dashboard/
```

If required:

1. Update local data-source paths.
2. Verify the relationships.
3. Verify the Calendar table.
4. Refresh the model.
5. Open the report pages.

> **Requirement:** Power BI Desktop is required to open and edit `.pbix`
> files.

---

# 🧠 Skills Demonstrated {#brain-skills-demonstrated}

* Python / Pandas
* Exploratory Data Analysis
* Data Cleaning & Preprocessing
* Data Quality Validation
* SQL Querying
* SQL Joins & Aggregations
* Relational Data Modeling
* Fact and Dimension concepts
* Power BI Data Modeling
* DAX Measures
* Filter Context
* Time-based Analysis
* KPI Development
* Interactive Dashboard Design
* Customer Segmentation
* Product Profitability Analysis
* Seller Performance Analysis
* Delivery & Operations Analytics
* Payment and Return Analysis

---

# 🚀 Project Workflow {#rocket-project-workflow}

**Raw Data → Python/Pandas → Clean Data → Diagnostic Analysis → SQL →
Data Modeling → DAX → Power BI → Business Insights**

This project demonstrates how multiple business datasets can be
connected and transformed into a structured analytics solution rather
than analyzing each table independently.

---

# 👨‍💻 Author {#man_technologist-author}

**Krishna Srivastava**

* GitHub: [Your GitHub Profile](https://github.com/your-username)
* LinkedIn: [Your LinkedIn
  Profile](https://www.linkedin.com/in/your-profile/)

---

## ⭐ Support {#star-support}

If you found this project useful, consider giving the repository a
**star ⭐**.

---

```{=html}
<div align="center">
```

### 🇮🇳 BharatKart Sales Analytics {#india-bharatkart-sales-analytics}

**From raw e-commerce data to business insights.**

```{=html}
</div>
```
