import streamlit as st
import requests
import logging
import pandas as pd

from modules.nav import SideBarLinks


logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks()

# Set the page title
st.title("Skill Analysis")
st.write("\n\n")

col1, col2 = st.columns(2)

department_id = st.session_state.get('department_ID', 1)

course_data = requests.get(f'http://api:4000/d/course/{department_id}').json()

courseid = []
departmentid = []
description = []
name = []
skills = []

for i in course_data:
    courseid.append(i['courseID'])
    departmentid.append(i['departmentID'])
    description.append(i['description'])
    name.append(i['name'])
    skills.append(i['CourseSkills.name'])

data = {
    'Course Num': courseid,
    'Department Num': departmentid,
    'Course Name': name,
    'Course Description':description,
    'Associated Skills': skills
}

df = pd.DataFrame(data)

st.subheader('List of Courses')
for _, row in df.iterrows():
    with st.expander(f"{row['Course Name']}"):
        st.write(f"Description: {row['Course Description']}")
        st.write(f"Associated Skill: {row['Associated Skills']}")

if st.button("Add New Course!"):
    st.switch_page('pages/AddCourse.py')

