# Customer Churn Prediction System 🚀

A full-stack **Customer Churn Prediction System** that combines **SQL database design, machine learning, Python automation, stored procedures, triggers, and analytics dashboards**.

This project predicts whether a customer is likely to churn and stores predictions directly in a MySQL database for business decision-making and retention workflows.

---

## 📌 Project Overview

This project simulates a real-world telecom/subscription business use case where customer behavior is analyzed to predict churn risk.

The system includes:

- 📂 **Structured MySQL database** with normalized tables
- 🤖 **Machine Learning model** trained on customer behavior
- 🔮 **Single customer prediction script**
- 🗂️ **Batch prediction from database**
- 🧠 **Stored procedure-based prediction inserts**
- 📊 **Analytics chart generation**
- 🛡️ **Retention action support through SQL triggers**

---

## 🏗️ Project Structure

```text
Customer_Churn_Project/
│
├── Customer_Churn_Dataset.csv
├── train_model.ipynb
├── churn_model.pkl
├── Queries.sql
├── Analytics_Charts_Generation.py
│
├── Prediction_using_db/
│   ├── Single_User_Prediction.py
│   └── Multiple_Users_Prediction_using_db.py
```

---

## 🛠️ Tech Stack

- **Python** → Numpy, Pandas, Joblib, Matplotlib, Seaborn
- **Machine Learning** → Scikit-learn
- **Database** → MySQL
- **SQL Concepts Used**
  - Joins
  - Stored Procedures
  - Triggers
  - Foreign Keys
  - Normalization
- **Visualization** → Seaborn + Matplotlib

---

## 🧠 Machine Learning Features Used

The model uses the following features:

- `age`
- `tenure`
- `monthly_charges`
- `last_login_days`
- `complaints`

### 🎯 Output

- `predicted_label` → 0 or 1
- `churn_probability` → probability score from `predict_proba()`

---

## 🗄️ Database Design

The MySQL database contains the following tables:

- `customers`
- `locations`
- `usage_data`
- `subscriptions`
- `support_interactions`
- `predictions`
- `retention_actions`

### 🔗 Relationships

- One customer belongs to one location
- One customer has usage data
- One customer has subscription data
- One customer can have multiple support interactions
- Predictions are stored historically

---

## 🔍 Key Functionalities

### 1) Single User Prediction

Predict churn for one customer using manual terminal input.

```bash
python Single_User_Prediction.py
```

### 2) Batch Prediction Using Database

Fetches customer features from MySQL, predicts churn for all users, and stores results using a stored procedure.

```bash
python Multiple_Users_Prediction_using_db.py
```

### 3) Analytics Dashboard Charts

Generates:

- Churn distribution
- Top churn-risk cities
- High-risk customer heatmap
- Age distribution

```bash
python Analytics_Charts_Generation.py
```

---

## 📊 Business Impact

This project helps businesses:

- Identify high-risk customers early
- Run retention campaigns
- Analyze churn by city and age
- Reduce customer loss
- Automate prediction workflows

---

## ⭐ Highlights / Advanced Concepts

What makes this project strong:

- ✅ End-to-end ML + SQL integration
- ✅ Real database workflow
- ✅ Stored procedure usage
- ✅ Historical prediction storage
- ✅ Automated analytics reporting
- ✅ Business-oriented architecture

---

## 🚀 Future Improvements

Planned upgrades:

- 🌐 Flask/Streamlit web dashboard
- 📈 Live KPI dashboard cards
- 📩 Email alerts for high-risk users
- ☁️ Cloud deployment (Render/AWS)
- 🔁 Model retraining pipeline
- 🔐 Environment variables for DB credentials
- 📦 REST API endpoints

---

## ▶️ How to Run

1. Import `Queries.sql` into MySQL
2. Train the model from `train_model.ipynb`
3. Ensure `churn_model.pkl` is generated
4. Update DB credentials in Python scripts
5. Run prediction scripts
6. Generate analytics charts

---

## 👨‍💻 Author

**Manav Kumar**

Second Year / Academic Major Project — **Customer Churn Prediction System**

---

## 📜 License

This project is for **learning, academic, and portfolio purposes**.


