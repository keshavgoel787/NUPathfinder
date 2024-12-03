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
    student_skills = requests.get('http://api:4000/d/totalstudent').json()
    skillname = []
    total = []
    st.subheader('Total Student Skill Count')
    for i in student_skills:
        skillname.append(i['name'])
        total.append(i['total'])

    df1 = pd.DataFrame(
        {
            'Skills': skillname,
            'Skill Total': total
        }
    )

    st.bar_chart(df1, x = 'Skills', y='Skill Total')

    st.subheader('Total Job Skill Count')
    job_skills = requests.get('http://api:4000/d/totaljob').json()
    skillname = []
    total = []
    for i in job_skills:
        skillname.append(i['name'])
        total.append(i['total'])

    df2 = pd.DataFrame(
        {
            'Skills': skillname,
            'Skill Total': total
        }
    )

    st.bar_chart(df2, x = 'Skills', y='Skill Total')


with col2:

    skill_gaps = requests.get('http://api:4000/d/Gaps').json()
    courses = requests.get('http://api:4000/d/course/recommend').json()

    st.subheader('Skill Gaps to Address')
    skills =[i['skill_name'] for i in skill_gaps]
    for i in skills:
        st.write(i)

    st.subheader('Courses to Recommend Students:')

    course_list = [[i['name'], i['skill_name']] for i in courses]

    for i in course_list:
        st.write(f"Course: {i[0]} | Skill: {i[1]}")
    

    st.subheader('Recommended Courses to Create')
    
st.write("Search Jobs")
st.write("Search Courses")
