# 🛒 E-Commerce Sales & Customer Insights Analysis
### An End-to-End Data Analytics Project on the Olist Brazilian E-Commerce Dataset

---

## 📌 Project Overview

This project presents a complete end-to-end data analytics pipeline on the **Olist Brazilian E-Commerce Dataset** (100,000+ orders). The goal was to analyze sales performance, understand customer behavior, identify churn risk, and deliver actionable business insights through an interactive Power BI dashboard.

> **Business Problem:** Olist wants to understand its sales performance, identify high-value customers, reduce churn, and improve delivery efficiency to increase overall revenue.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white) | Data storage & business querying |
| ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white) | Data cleaning, EDA & RFM Analysis |
| ![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat&logo=powerbi&logoColor=black) | Interactive dashboard & visualization |

---

## 🔄 Project Pipeline

```
Raw CSV Files
     ↓
MySQL Database (olist_db)
     ↓
Python — Data Cleaning
     ↓
Python — EDA & RFM Analysis
     ↓
Power BI — Interactive Dashboard
```

---

## ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white) Stage 1 — SQL Analysis

Loaded all 9 CSV tables into MySQL and wrote **14 business queries** across 4 categories:

**Sales Analysis**
- Total revenue generated — **16.01M BRL**
- Monthly revenue trend
- Top 10 product categories by revenue
- Average order value — **154.10 BRL**
- Orders placed per year

**Customer Analysis**
- Total unique customers — **96,096**
- States with highest customers
- Repeat purchase customers — **2,875**

**Order & Delivery Analysis**
- Order status distribution
- Average delivery time — **12.50 days**
- Late orders — **7,826**

**Product & Seller Analysis**
- Top 10 sellers by revenue
- Average review score per category

**Advanced Analysis**
- Month-over-Month revenue growth % using `LAG()` window function

---

## ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white) Stage 2 — Data Cleaning

Connected to MySQL via SQLAlchemy and performed the following cleaning steps:

| Table | Issue | Action |
|---|---|---|
| `orders` | Missing delivery dates | Left as NULL — meaningful missing values |
| `order_reviews` | Missing comment title & message | Filled with `'No Review'` |
| `products` | Missing category names | Filled with `'Unknown'` |
| `products` | Missing numerical values | Filled with **median** |
| All tables | Duplicates | None found |
| `orders`, `order_items`, `order_reviews` | Date columns stored as strings | Converted to `datetime64` |

---

## ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white) Stage 3 — Exploratory Data Analysis

Performed EDA using **Pandas, Matplotlib and Seaborn** with SQL queries reused via `pd.read_sql()`:

**1. Monthly Revenue Trend**
- 2017 showed steady growth with a peak in **November** (Black Friday effect)
- 2018 data available only until August

**2. Top 10 Product Categories by Revenue**
- **Bed & Bath Table** is the highest revenue category at ~1.7M BRL
- Top 3 categories contribute significantly more than the rest

**3. Order Status Distribution**
- **96,478 orders (97%)** successfully delivered — very high fulfillment rate
- Less than 1% cancellation rate

**4. Product Category Review Analysis**
- **CDs, DVDs & Musicals** is the best reviewed category (~4.6 avg score)
- **Security & Services** is the worst reviewed category (~3.3 avg score)
- Even the worst categories score above 3.0

**5. Delivery Time Distribution**
- Most orders delivered within **10-20 days**
- Right skewed distribution — majority of deliveries are fast

**6. Payment Type Distribution**
- **Credit card** dominates at **73.9%**
- **Boleto** (Brazilian bank slip) is second at **19%**

---

## ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white) Stage 4 — RFM Analysis

Performed **RFM (Recency, Frequency, Monetary) segmentation** to classify 96,477 customers:

| Metric | Definition |
|---|---|
| **Recency** | Days since last purchase — lower is better |
| **Frequency** | Number of orders placed — higher is better |
| **Monetary** | Total amount spent — higher is better |

**Customer Segments:**

| Segment | Count | % |
|---|---|---|
| Lost Customers | 33,959 | 35.2% |
| New Customers | 15,627 | 16.2% |
| Loyal Customers | 14,801 | 15.3% |
| At Risk | 13,641 | 14.1% |
| Cannot Lose Them | 8,989 | 9.3% |
| Champions | 6,330 | 6.6% |
| Potential Loyalists | 3,130 | 3.2% |

**Lost Customer Investigation:**

We investigated why 33,959 customers were lost across 3 angles:

| Angle | Lost Customers | Champions | Conclusion |
|---|---|---|---|
| Avg Review Score | 4.19 | 4.12 | ❌ Not the reason |
| Avg Delivery Delay | -11.65 days | -12.41 days | ❌ Not the reason |
| Product Categories | Same as overall top categories | — | ❌ Not the reason |

> ✅ **Key Finding:** Olist is a **one-time purchase platform** — most customers buy once and don't return. This is normal behavior for e-commerce marketplaces in Brazil.

---

## ![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat&logo=powerbi&logoColor=black) Stage 5 — Power BI Dashboard

Built a **3-page interactive dashboard** connected directly to MySQL:

- **Page 1 — Sales Overview:** Revenue KPIs, monthly trend, top categories
- **Page 2 — Customer Insights & RFM:** Customer segments, map, payment types
- **Page 3 — Delivery & Review Analysis:** Delivery KPIs, best/worst reviewed categories

---

## 💼 Business Insights & Recommendations

### 📈 Revenue
- Total revenue of **16.01M BRL** with consistent growth in 2017
- **November is the peak month** — driven by Black Friday. Recommend increasing inventory and running targeted campaigns in October-November
- **Bed & Bath Table, Health & Beauty and Computers** are the top 3 revenue categories — prioritize these for promotions

### 👥 Customer Retention
- Only **2,875 repeat customers** out of 96,477 — **2.98% repeat rate** is very low
- **33,959 lost customers** — largest segment at 35%
- Recommend launching a **loyalty/rewards program** to incentivize repeat purchases
- **13,641 At Risk customers** should be targeted with **re-engagement email campaigns**
- **8,989 Cannot Lose Them** customers were once high spenders — offer **exclusive discounts** to win them back
- **6,330 Champions** should be rewarded with **VIP perks** to maintain loyalty

### 🚚 Delivery
- Average delivery time of **12.50 days** is reasonable but can be improved
- **7,826 late orders** — recommend improving logistics partnerships in high-delay regions
- Orders are generally delivered **11-12 days before estimated date** — estimated dates are too conservative, which may reduce customer satisfaction expectations

### ⭐ Product Quality
- Overall average review score of **4.09/5** — strong customer satisfaction
- **Security & Services** (2.5) and **Diapers & Hygiene** (3.3) have the lowest scores — require immediate quality improvement
- Even worst-rated categories score above 3.0 — no critical quality failures

### 💳 Payments
- **73.9% credit card usage** — ensure seamless credit card checkout experience
- **19% Boleto users** — a significant segment, ensure Boleto payments are prioritized
- Consider introducing **EMI options** to increase average order value

---

## 📊 Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

| Table | Rows |
|---|---|
| customers | 99,441 |
| orders | 99,441 |
| order_items | 112,650 |
| order_payments | 103,886 |
| order_reviews | 99,224 |
| products | 32,951 |
| sellers | 3,095 |
| category_translate | 71 |

---
