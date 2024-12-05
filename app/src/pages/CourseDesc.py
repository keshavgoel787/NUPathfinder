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

st.title(f"Update Info for {st.session_state['Current Course']}")

courseid = st.session_state['Current Course #']
department_id = st.session_state.get('department_ID', 1)

with st.form("add_listing_form"):
    
    # Create the various input widgets needed for 
    # each piece of information you're eliciting from the user
    course_name = st.text_input(label="Course Name", value=st.session_state['Current Course'])
    course_desc = st.text_area(label="Course description")
 
    submit_button = st.form_submit_button()

    if submit_button:
        if not course_name:
            st.error("Please enter a job position")
        elif not course_desc:
            st.error("Please enter a job description")
        else:
            # We only get into this else clause if all the input fields have something 
            # in them. 
            #
            # Package the data up that the user entered into 
            # a dictionary (which is just like JSON in this case)
            course_data = {
                "cname": course_name,
                "cdescription": course_desc,
            }

            logger.info(f"Course form submitted with data: {course_data}")
            
            try:
                url = f"http://api:4000/d/updatecourseinfo/{department_id}/{courseid}"
                response = requests.put(url, json=course_data)
                if response.status_code == 200:
                    st.success("Course edited successfully!")
                    st.switch_page("pages/ManageCourses.py")
                else:
                    st.error(f"Error editing Course: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")