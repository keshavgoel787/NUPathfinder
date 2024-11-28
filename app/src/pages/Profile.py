import streamlit as st
import requests
import logging

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Set the page title
st.title("My Profile")
st.write("\n\n")

# Display existing skills - assuming there's an endpoint to fetch current skills
student_id = st.session_state.get('student_id', 1)  # Example of retrieving student ID from session state
response = requests.get(f'http://localhost:5000/students/{student_id}/skills')

if response.status_code == 200:
    skills = response.json()
    if skills:
        st.write("### Current Skills")
        for skill in skills:
            st.write(f"Skill: {skill['skill_name']}, Proficiency: {skill['proficiency']}")
    else:
        st.write("You currently have no skills listed.")
else:
    st.error("Error loading skills.")

st.write("\n\n")

# Add a new skill
st.write("### Add a New Skill")
skill_name = st.text_input("Skill Name")
skill_proficiency = st.slider("Proficiency (1-5)", 1, 5, 1)

if st.button('Add Skill', type='primary', use_container_width=True):
    if skill_name:
        payload = {
            'skill_name': skill_name,
            'proficiency': skill_proficiency,
            'student_id': student_id
        }
        response = requests.post(f'http://localhost:5000/addSkill', json=payload)
        if response.status_code == 200:
            st.success("Successfully added skill.")
            st.experimental_rerun()
        else:
            st.error("Failed to add skill.")
    else:
        st.warning("Please enter a skill name.")

# Update skill proficiency
st.write("### Update Skill Proficiency")
skill_to_update = st.selectbox("Select Skill to Update", [skill['skill_name'] for skill in skills] if skills else [])
new_proficiency = st.slider("New Proficiency (1-5)", 1, 5, 1)

if st.button('Update Skill', type='primary', use_container_width=True):
    if skill_to_update:
        skill_id = next((skill['id'] for skill in skills if skill['skill_name'] == skill_to_update), None)
        if skill_id:
            payload = {'proficiency': new_proficiency}
            response = requests.put(f'http://localhost:5000/skill/{skill_id}', json=payload)
            if response.status_code == 200:
                st.success("Successfully updated skill proficiency.")
                st.experimental_rerun()
            else:
                st.error("Failed to update skill.")
    else:
        st.warning("Please select a skill to update.")

# Delete a skill
st.write("### Delete a Skill")
skill_to_delete = st.selectbox("Select Skill to Delete", [skill['skill_name'] for skill in skills] if skills else [], key='delete')

if st.button('Delete Skill', type='primary', use_container_width=True):
    if skill_to_delete:
        skill_id = next((skill['id'] for skill in skills if skill['skill_name'] == skill_to_delete), None)
        if skill_id:
            response = requests.delete(f'http://localhost:5000/skill/{skill_id}')
            if response.status_code == 200:
                st.success("Successfully deleted skill.")
                st.experimental_rerun()
            else:
                st.error("Failed to delete skill.")
    else:
        st.warning("Please select a skill to delete.")
