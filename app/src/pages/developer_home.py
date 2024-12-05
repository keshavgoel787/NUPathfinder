import logging
import streamlit as st
from modules.nav import SideBarLinks

logger = logging.getLogger(__name__)

st.set_page_config(layout='wide')

SideBarLinks(show_home=True)

# Welcome message
st.title(f"Welcome Developer, {st.session_state['developer_name']}!")
st.write("")
st.write("")
st.write("### What would you like to do today?")

# Buttons to navigate 
if st.button('View Data Logs', type='primary', use_container_width=True):
    st.switch_page('pages/View_DataLogs.py')

if st.button('Manage Testing', type='primary', use_container_width=True):
    st.switch_page('pages/Manage_Testing.py')

if st.button('Manage User Feedback', type='primary', use_container_width=True):
    st.switch_page('pages/Manage_Feedback.py')
