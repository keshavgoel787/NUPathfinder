import streamlit as st
from modules.nav import SideBarLinks



st.set_page_config(layout='wide')
SideBarLinks(show_home=True)

st.title("Manage User Feedback")
st.write("View and prioritize feedback from users.")

# Placeholder table for user feedback
feedback_data = [
    {"Feedback ID": 1, "Rating": 5, "Comments": "Great feature!", "Timestamp": "2024-11-20"},
    {"Feedback ID": 2, "Rating": 3, "Comments": "Needs improvement.", "Timestamp": "2024-11-21"},
]

st.write("### User Feedback")
st.table(feedback_data)

st.write("### Archive Feedback")
feedback_id = st.text_input("Enter Feedback ID to Archive")

if st.button("Archive Feedback"):
    st.success(f"Feedback {feedback_id} archived successfully.")
