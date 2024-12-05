import logging 
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
import array
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title("Add new skill")


with st.form("Add skill"):

    skill_name = st.text_input("Skill name")
    skill_description = st.text_area(("description"))
    skill_category = st.text_input("Category")

    submit_button = st.form_submit_button("Add skill")

    if submit_button: 
        if not skill_name:
            st.error('please insert a name for this new skill')
        if not skill_description:
            st.error('please insert a description for this new skill')
        if not skill_category:
            st.error('please insert a category for this new skill')
        else:
            skill_data = {
                "name": skill_name,
                "description" : skill_description,
                "category": skill_category
            }
            try:
                response = requests.post("http://api:4000/r/addSkill", json=skill_data)
                if response.status_code == 200:
                    st.success("Skill added successfully!")
                    if st.session_state['role'] == 'Department_Head':
                        st.switch_page('pages/CourseSkill.py')
                    else:
                        st.switch_page('pages/jobSkill.py')
                else:
                    st.error(f"Error adding skill: {response.text}")
            except requests.exceptions.RequestException as e:
                    st.error(f"Error connecting to server: {str(e)}")

