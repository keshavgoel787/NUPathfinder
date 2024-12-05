import streamlit as st

st.set_page_config(layout='wide')
st.title("Manage Testing")
st.write("Log automated test results and view testing history.")

# Log new test results
st.subheader("Log New Test Results")
feature_id = st.text_input("Feature ID")
test_type = st.selectbox("Test Type", ["Unit Test", "Integration Test", "Regression Test"])
result = st.selectbox("Result", ["Passed", "Failed"])
run_date = st.date_input("Run Date")

if st.button("Log Test Results"):
    st.success(f"Test result for Feature ID {feature_id} logged successfully.")

# View testing history (placeholder data)
st.subheader("Testing History")
test_results = [
    {"Feature ID": 1, "Test Type": "Unit Test", "Result": "Passed", "Run Date": "2023-12-01"},
    {"Feature ID": 2, "Test Type": "Regression Test", "Result": "Failed", "Run Date": "2023-11-28"},
]
st.table(test_results)
