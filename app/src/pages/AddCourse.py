import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
import array
import datetime
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

SideBarLinks()

department_id = st.session_state.get('department_ID', 1)

st.title(f"Plan a New Course for Department {department_id}")


with st.form("add_course_form"):

    # Create the various input widgets needed for 
    # each piece of information you're eliciting from the user
    course_name = st.text_input("Course Name")
    course_description = st.text_area(("Course description"))

    submit_button = st.form_submit_button("Add Course")

    if submit_button:
        if not course_name:
            st.error("Enter Course Name")
        elif not course_description:
            st.error("Enter Course Description")
        else:

            course_data = {
                "name":course_name,
                "description":course_description
            }

            logger.info(f"Course form submitted with data: {course_data}")

            url = f"http://api:4000/d/addcourse/{department_id}"
            response = requests.post(url, json=course_data)
            st.success("Successfully added note.")




        



