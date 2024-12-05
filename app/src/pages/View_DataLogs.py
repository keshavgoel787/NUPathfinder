import streamlit as st
from modules.nav import SideBarLinks



st.set_page_config(layout='wide')
SideBarLinks(show_home=True)

st.title("View Data Logs")
st.write("Here you can monitor and fix data inconsistencies.")

# Placeholder table for data logs
data_logs = [
    {"Log ID": 1, "Details": None, "Timestamp": "2023-12-05"},
    {"Log ID": 2, "Details": "Error fixed", "Timestamp": None},
]

st.write("### Data Logs with Inconsistencies")
st.table(data_logs)

st.write("### Fix Data Logs")
log_id = st.text_input("Enter Log ID to Fix")
details = st.text_input("Details")
timestamp = st.date_input("Timestamp")

if st.button("Fix Data Log"):
    st.success(f"Log {log_id} updated successfully.")
