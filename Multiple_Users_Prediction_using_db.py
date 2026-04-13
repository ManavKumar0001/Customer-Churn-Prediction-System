import pandas as pd
import mysql.connector
import joblib


try:
    # -------------------------------
    # Database Connection
    # -------------------------------
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="M^1G^6V^3##&&@2897_se",
        database="customer_churn_system"
    )

    cursor = conn.cursor()

    # -------------------------------
    # Load trained model
    # -------------------------------
    model = joblib.load("churn_model.pkl")

    # -------------------------------
    # Fetch customer features
    # -------------------------------
    query = """
    SELECT 
        c.customer_id,
        c.age,
        u.tenure,
        s.monthly_charges,
        u.last_login_days,
        CASE 
            WHEN si.complaints > 0 THEN 1
            ELSE 0
        END AS complaints
    FROM customers c
    JOIN locations l ON c.location_id = l.location_id
    JOIN usage_data u ON c.customer_id = u.customer_id
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN support_interactions si ON c.customer_id = si.customer_id
    """

    cursor.execute(query)
    rows = cursor.fetchall()

    # -------------------------------
    # Predict for each customer
    # -------------------------------
    for row in rows:
        customer_id, age, tenure, monthly_charges, last_login_days, complaints = row

        sample = pd.DataFrame([{
            "age": age,
            "tenure": tenure,
            "monthly_charges": monthly_charges,
            "last_login_days": last_login_days,
            "complaints": complaints
        }])

        predicted_label = model.predict(sample)[0]
        churn_probability = model.predict_proba(sample)[0][1]

        # -----------------------------------------
        # CALL STORED PROCEDURE INSTEAD OF INSERT
        # -----------------------------------------
        cursor.callproc("insert_prediction", [
            customer_id,
            float(churn_probability),
            int(predicted_label)
        ])

    # -------------------------------
    # Save all inserts
    # -------------------------------
    conn.commit()
    print("All predictions stored successfully ✅\n\n\n\n")

    

except Exception as e:
    conn.rollback()
    print("Failed row:", row)
    print("Error:", e)
    
finally:
    cursor.close()
    conn.close()
