import streamlit as st
import requests
import logging
from modules.nav import SideBarLinks

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks(show_home=True)

# Set the page title
st.title("My Profile")
st.write("\n\n")

# Base API URL
url = 'http://api:4000/s'

# Initialize skills variable
skills = []

# Fetch student ID from session or use default
student_id = st.session_state.get('student_id', 1)

try:
    # Retrieve student's skills from the API
    response = requests.get(f"{url}/studentSkills/{student_id}")
    logger.info(f"Request URL: {response.url}")
    response.raise_for_status()
    skills = response.json()
    logger.info(f"Skills fetched: {skills}")

    if skills:
        st.write("### Current Skills")
        for skill in skills:
            st.write(f"Skill: {skill['name']}, Proficiency: {skill['proficiency']}")
    else:
        st.write("You currently have no skills listed.")
except requests.RequestException as err:
    logger.error(f"Error: {err}, Response: {err.response.text if err.response else 'No response'}")
    st.error("Error loading skills.")
    skills = []

st.write("\n\n")

if 'reload' not in st.session_state:
    st.session_state['reload'] = False

# Add a new skill
with st.form("add_skill_form"):
    st.write("### Add a New Skill")
    skill_name = st.text_input("Skill Name")
    skill_proficiency = st.slider("Proficiency (1-5)", 1, 5, 1)
    submit_button = st.form_submit_button("Add Skill")

    if submit_button:
        if not skill_name:
            st.error("Please enter a skill name")
        else:
            try:
                data = {
                    "student_id": student_id,
                    "skill_name": skill_name,
                    "skill_proficiency": skill_proficiency
                }
                response = requests.post(f"{url}/studentSkills/{student_id}", json=data)
                response.raise_for_status()
                st.success("Successfully added skill.")
                st.session_state['reload'] = True
            except requests.RequestException as err:
                logger.error(f"Error: {err}")
                st.error("Failed to add skill.")

# Update skill proficiency
with st.form("update_skill_form"):
    st.write("### Update Skill Proficiency")
    skill_to_update = st.selectbox("Select Skill to Update", [skill['name'] for skill in skills] if skills else [])
    new_proficiency = st.slider("New Proficiency (1-5)", 1, 5, 1, key='update')
    update_button = st.form_submit_button("Update Skill")

    if update_button:
        if not skill_to_update:
            st.warning("Please select a skill to update.")
        else:
            try:
                data = {
                    "proficiency": new_proficiency
                }
                response = requests.put(f"{url}/studentSkills/{student_id}/{skill_to_update}", json=data)
                response.raise_for_status()
                st.success("Successfully updated skill proficiency.")
                st.session_state['reload'] = True
            except requests.RequestException as err:
                logger.error(f"Error: {err}")
                st.error("Failed to update skill.")

# Delete a skill
with st.form("delete_skill_form"):
    st.write("### Delete a Skill")
    skill_to_delete = st.selectbox("Select Skill to Delete", [skill['name'] for skill in skills] if skills else [], key='delete')
    delete_button = st.form_submit_button("Delete Skill")

    if delete_button:
        if not skill_to_delete:
            st.warning("Please select a skill to delete.")
        else:
            try:
                response = requests.delete(f"{url}/studentSkills/{student_id}/{skill_to_delete}")
                response.raise_for_status()
                st.success("Successfully deleted skill.")
                st.session_state['reload'] = True
            except requests.RequestException as err:
                logger.error(f"Error: {err}")
                st.error("Failed to delete skill.")
