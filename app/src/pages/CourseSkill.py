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
 
st.title(f"Update skill for {st.session_state['Current Course']}")

courseid = st.session_state['Current Course #']
department_id = st.session_state.get('department_ID', 1)

skill_request = requests.get(f'http://api:4000/d/courseskills/{courseid}').json()

skills = requests.get("http://api:4000/r/jobs/skills").json()

skillsArray =[]

for i in skills:
    skillsArray.append(i['name'])

st.write("### Current Assigned Skills")
skills = [i['name'] for i in skill_request]
st.write(i +", " for i in skills)
st.write("---")

with st.form("add_skill_form"):
    st.write("### Add a New Skill")
    skillOption = st.selectbox("Select which skill you would like to add to this job",
    skillsArray)
    submit_button = st.form_submit_button("Add Skill")

    if submit_button:
        if not skillOption:
            st.error("Please enter a skill name")
        else:
            try:
                data = {
                    "student_id": courseid,
                    "skill_name": skillOption,
                }
                response = requests.post(f"http://api:4000/d/addcourseskill/{courseid}", json=data)
                response.raise_for_status()
                st.success("Successfully added skill.")
                st.rerun()
            except requests.RequestException as err:
                logger.error(f"Error: {err}")
                st.error("Failed to add skill.")

if st.button("Or create a new skill", 
    type = 'primary', 
    use_container_width=True):
    st.session_state['role'] = 'Department_Head'
    st.switch_page('pages/addSkill.py')