import streamlit as st
import requests
import logging

from modules.nav import SideBarLinks


logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks()


# Set the page title
st.title("Skill Analysis")
st.write("\n\n")

department_id = st.session_state.get('department_ID', 1)
skill_gaps = requests.get('http://api:4000/d/Gaps').json()

st.subheader('Skill Gaps to Address')
for i in skill_gaps:
    st.write(i['name'])

student_skills = requests.get('http://api:4000/d/totalstudent').json()

st.subheader('Total Student Skill Count')
for i in student_skills:
    st.write(i['name'], i['total'])

