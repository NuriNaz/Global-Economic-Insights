# Global-Economic-Insights

# 🌍 Global Economic Insights: From Raw Data to Business Intelligence  

###  A Data Analytics Journey with Python, SQL, DAX & Power BI  

> *“Behind every economy lies a story told through data — my goal was to uncover that story.”*  

---

##  Project Overview  

In today’s fast-changing world, understanding how economies perform — which countries grow faster, who struggles with unemployment, and how inflation shapes regions — is vital.  

This project takes **raw global economic data** and transforms it into meaningful insights using the **end-to-end analytics lifecycle**:  
**Data Cleaning (Python)** → **Exploration (SQL)** → **KPI Modeling (DAX)** → **Visualization (Power BI)**  

The final dashboard gives a **global snapshot** of economic health, helping users visualize:
- Top and bottom countries by GDP  
- Regional GDP per capita patterns  
- Jobless rates and growth correlations  
- Key performance indicators (KPIs) for inflation, growth, and population  

---

##  Tools & Technologies  

| Stage | Tool | Purpose |
|--------|------|----------|
|  **Python (Pandas, NumPy)** | Data cleaning & preparation |
|  **SQL Server** | Querying, aggregations & insights |
|  **DAX in Power BI** | KPI and measure creation |
| **Power BI Desktop** | Interactive visualization |
| **GitHub** | Version control & portfolio showcase |

---

## Step 1: Data Cleaning with Python  

**Goal:** Convert messy world economic data into a reliable dataset ready for analysis.  

**File:** `world_economics.csv` → **Output:** `cleaned_world_economics.csv`

### Key Cleaning Steps:
- Standardized inconsistent column names and formats  
- Removed duplicates and missing values  
- Converted text-based numbers like `"1,200"` or `"5%"` into pure numeric form  
- Derived a new metric — **GDP per Capita (GDP ÷ Population)**  

```python
import pandas as pd
import numpy as np

df = pd.read_csv("world_economics.csv")

# Standardize column names
df.columns = (df.columns.str.strip()
             .str.lower()
             .str.replace(" ", "_")
             .str.replace(r"[%()/]", "", regex=True))

# Clean numeric columns
num_cols = ["gdp","gdp_growth","interest_rate","inflation_rate",
            "jobless_rate","gov_budget","debt_gdp","current_account",
            "population","area","latitude","longitude"]

for col in num_cols:
    if col in df.columns:
        df[col] = (df[col].astype(str)
                          .str.replace(",", "")
                          .str.replace("%", "")
                          .str.replace("$", "")
                          .str.strip()
                          .replace(["", "nan", "NaN", "N/A"], np.nan))
        df[col] = pd.to_numeric(df[col], errors="coerce")

# Remove duplicates & standardize text
df = df.drop_duplicates(subset=["name"])
text_cols = ["name","currency","capital","languages","region","subregion","borders"]
for col in text_cols:
    if col in df.columns:
        df[col] = df[col].astype(str).str.strip().str.title().replace("Nan", np.nan)

# Derived metric: GDP per capita
df["gdp_per_capita"] = np.where((df["population"]>0),
                                df["gdp"]/df["population"], np.nan)

df.to_csv("cleaned_world_economics.csv", index=False)
print("✅ Cleaned file saved successfully!")

```
 *Outcome:*  
A clean, structured dataset with consistent numeric formatting — ready for SQL exploration and Power BI ingestion.

---

##  Step 2: Data Exploration with SQL  

Once cleaned, the dataset was imported into SQL Server to uncover hidden economic patterns.  

###  Key SQL Queries & Insights
#### **KPI**
```SQL

SELECT ROUND(AVG(gdp_growth)*100,1) AS Avg_GDP_Growth_Percent FROM cleaned_world_economics;
SELECT ROUND(AVG(inflation_rate),1) AS Avg_Inflation FROM cleaned_world_economics;
SELECT CONCAT(ROUND(SUM(GDP)/1000,1),'K') AS Total_GDP FROM cleaned_world_economics;
SELECT CONCAT(ROUND(SUM(population)/1000,1),'K') AS Total_Population FROM cleaned_world_economics;
```

####  **Top 10 Economies by GDP**
```sql
SELECT TOP 10 name, GDP
FROM cleaned_world_economics
ORDER BY GDP DESC;
```
> *These countries dominate global GDP, showcasing where most of the world’s economic output is concentrated.*

####  **GDP per Capita Leaders**
```sql
SELECT TOP 10 name, ROUND(GDP * 1.0 / Population, 2) AS GDP_Per_Capita
FROM cleaned_world_economics
ORDER BY GDP_Per_Capita DESC;
```
> *Reveals nations with high individual wealth even if total GDP is small — often smaller, high-income economies.*

#### **Regional Economic Indicators**
```sql
SELECT region,
       ROUND(AVG(gdp_growth),2) AS Avg_GDP_Growth,
       ROUND(AVG(inflation_rate),2) AS Avg_Inflation,
       ROUND(AVG(jobless_rate),2) AS Avg_Jobless
FROM cleaned_world_economics
GROUP BY region;
```
> *Shows how different regions balance growth and stability — useful for comparing continents.*

####  **Growth vs Employment**
```sql
SELECT name, gdp_growth, jobless_rate
FROM cleaned_world_economics
WHERE gdp_growth > 5 AND jobless_rate < 5
ORDER BY gdp_growth DESC;
```
> *Helps identify countries achieving both growth and low unemployment — true economic success stories.*

 *Outcome:*  
Key statistical trends ready to be modeled into KPIs and Power BI visuals.

---

##  Step 3: DAX — Transforming Data into KPIs  

DAX (Data Analysis Expressions) was used in Power BI to build real-time indicators and comparative metrics.

| **KPI Measure** | **DAX Formula** | **Purpose** |
|------------------|------------------|-------------|
| **Total GDP (K)** | `ROUND(SUM(GDP)/1000,1)` | Global GDP in thousands |
| **Total Population (K)** | `ROUND(SUM(Population)/1000,1)` | Global population |
| **Average Inflation Rate** | `ROUND(AVERAGE(Inflation_Rate),1)` | Global price growth |
| **Average GDP Growth (%)** | `ROUND(AVERAGE(GDP_Growth)*100,1)` | Overall economic expansion |
| **GDP per Capita** | `DIVIDE(SUM(GDP), SUM(Population))` | Individual wealth measure |
| **High Growth, Low Jobless Flag** | `IF(GDP_Growth>5 && Jobless_Rate<5,"Yes","No")` | Identifies balanced economies |

 *Outcome:*  
These measures powered KPI cards and charts in the dashboard to make insights instantly visible.

---

##  Step 4: Power BI Visualization  

Once the data model was complete, the final visualization phase brought the story to life through **interactive dashboards**.

###  **Home Page — Global Snapshot**

**KPI Cards:**  
-  Total GDP  
-  Total Population  
-  Avg GDP Growth  
-  Avg Inflation Rate  

**Visuals:**  
- **World Map:** Global GDP distribution by country  
- **Bar Chart:** Top 10 countries by GDP  
- **Column Chart:** GDP per capita by region  
- **Bar Chart:** Top 5 countries by jobless rate  
- **Bar Chart:** Bottom 5 countries by jobless rate  
- **Scatter Plot:** GDP per capita vs jobless rate  

> *This page gives an instant bird’s-eye view of global economic performance.*

---

###  **Economic Insights Page — Deep Dive**

**KPI Cards:**  
Same as home page, but filtered by 
**Visuals:**  
- Average economic indicators by region  (clustered column chart)
- Interest rate distribution (donut chart)  
- High-growth low-jobless segmentation (donut chart) 
- Detailed tables for GDP, population & jobless rate (table) 
- Interactive slicers for region and GDP filters  

> *This page helps decision-makers focus on region-specific trends and identify stable vs volatile economies.*

---

### 🔍 **Drill-Through Page — Country Details**

Each country can be clicked for a **deep dive** into:
- GDP per capita  
- Inflation & interest rate  
- Government budget  
- Current account  
- Jobless rate  
- language

> *This enables “zooming in” on any nation to study its economic health in context.*

---

##  Key Insights from Analysis  
 **1. GDP Distribution:**  
A handful of developed economies dominate global GDP output — notably the U.S., China, and Japan.  

 **2. Regional Growth Trends:**  
- Africa shows strong growth but faces high inflation and jobless rates.  
- Europe and Oceania display economic maturity with low unemployment.  
- Asia balances growth with moderate inflation.  

 **3. Employment Patterns:**  
There’s a **negative correlation** between GDP per capita and jobless rate — wealthier nations tend to have more stable labor markets.  

 **4. Policy Implications:**  
Countries achieving **high growth with low unemployment** reflect successful fiscal management and business environments.  

---



##  Final Outcome  

✅ End-to-end analytics pipeline: **Python → SQL → DAX → Power BI**  
✅ 3 interactive dashboards: **Home, Insights, Drill Through**  
✅ 10+ KPIs calculated for data-driven decision-making  
✅ Business-ready insights that narrate the story of the global economy  

---## 📸 Dashboard Preview  
🔗 **Dashboard Screenshot** → https://screenrec.com/share/BWOPsl2moI](https://screenrec.com/share/j6Pp0esWRE  
 https://screenrec.com/share/ZqWJ5aVNlG
 https://screenrec.com/share/ZSnlx6Xfu1
🔗 **SQL Queries Verification (Screen Recording)** → [Watch Here](https://screenrec.com/share/O39SYTxgJp)  
download dataset from Kaggle https://www.kaggle.com/datasets
To view the working **Power BI Dashboard (.pbit file)**:  
- Go to the repository → Click on the `.pbit` file → Select **View Raw** → It will download automatically after that you can open it in your power bi desktop
- for the dataset you can get from kaggle 

> *“Data tells the story — analytics gives it a voice.”*  
