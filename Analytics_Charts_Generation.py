import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import mysql.connector


conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="M^1G^6V^3##&&@2897_se",
    database="customer_churn_system"
)
# -------------------------------
# Create analytics dataset
# -------------------------------
analytics_query = """
    SELECT c.customer_id, c.age, l.city_name,
           s.monthly_charges,
           p.churn_probability,
           p.predicted_label
    FROM customers c
    JOIN locations l ON c.location_id = l.location_id
    JOIN subscriptions s ON c.customer_id = s.customer_id
    LEFT JOIN predictions p ON c.customer_id = p.customer_id
    """

df = pd.read_sql(analytics_query, conn)

# -------------------------------
# Create subplot figure
# -------------------------------
sns.set_theme(style="darkgrid")
fig, axes = plt.subplots(2, 2, figsize=(15, 10))

# CountPlot
sns.countplot(data=df, x="predicted_label", ax=axes[0, 0])
axes[0, 0].set_title("Churn Distribution")


# BarPlot
city_risk = (
    df.groupby("city_name")["churn_probability"]
    .mean()
    .sort_values(ascending=False)
    .head(25)
)

sns.barplot(
    data = city_risk,
    ax=axes[0, 1]
    )
axes[0, 1].set_title("Top 25 Cities by Churn Risk")


# HeatMap
high_risk = df[["customer_id", "churn_probability"]].head(25)

heatmap_data = high_risk.set_index("customer_id")

sns.heatmap(
    heatmap_data,
    annot=True,
    cmap="Blues",
    linewidths=0.5,
    ax=axes[1, 0]
)

axes[1, 0].set_title("High-Risk Customers Heatmap")



# Histogram
sns.histplot(
    data=df, 
    x="age", 
    kde=True, 
    ax=axes[1, 1]
    )
axes[1, 1].set_title("Age Distribution")


plt.tight_layout()
plt.savefig("customer_churn_analytics.png", dpi=300, bbox_inches="tight")
plt.close()

print("Analytics subplot image saved in same folder as customer_churn_analytics.png 📊")
