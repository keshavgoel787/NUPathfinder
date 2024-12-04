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

with col1:
    student_data = requests.get('http://api:4000/d/totalstudent').json()
    df_s = pd.DataFrame(student_data)
    df_s.rename(columns= {'name': 'Skills', 'total': '# of Students with Skill'}, inplace = True)
    st.subheader('Student Skill Count')
    st.bar_chart(df_s, x='Skills', y='# of Students with Skill')


    job_data = requests.get('http://api:4000/d/totaljob').json()
    df_j = pd.DataFrame(job_data)
    df_j.rename(columns= {'name': 'Skills', 'total': '# of Jobs that Request Skill'}, inplace = True)
    st.subheader('Job Skill Count')
    st.bar_chart(df_j, x='Skills', y='# of Jobs that Request Skill')


with col2:
    # Fetch data from the API
    skill_gaps = requests.get('http://api:4000/d/Gaps').json()
    courses = requests.get('http://api:4000/d/course/recommend').json()

    # Extract skills and courses in one go
    skills = {i['skill_name'] for i in skill_gaps}  # Use a set for faster lookups
    course_skills = {i['skill_name']: i['name'] for i in courses}  # Map skill_name to course name

    # Display skill gaps
    st.subheader('Skill Gaps to Address')
    for skill in skills:
        st.write(skill)

    # Display recommended courses
    st.subheader('Courses to Recommend Students:')
    for skill, course in course_skills.items():
        st.write(f"Course: {course} | Skill: {skill}")

    # Identify and display skills not covered by recommended courses
    st.subheader('Recommended Course Topics')
    uncovered_skills = skills - course_skills.keys()  # Set difference
    if len(uncovered_skills)<1:
        st.write('All Skills Accounted For!')
    else:
        for skill in uncovered_skills:
            st.write(skill)
    
    
if st.button('View All Inputted Skills',   
             type='primary',
             use_container_width=True):
    st.switch_page('pages/ManageSkills.py')

if st.button('Manage Current Courses',   
             type='primary',
             use_container_width=True):
    st.switch_page('pages/ManageCourses.py')