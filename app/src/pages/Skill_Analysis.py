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

def fetch_and_plot_data(api_url, title):
    """Fetch data from the API, create a DataFrame, and plot a bar chart."""
    data = requests.get(api_url).json()
    df = pd.DataFrame(data)
    df.rename(columns={'name': 'Skills', 'total': 'Skill Total'}, inplace=True)
    
    st.subheader(title)
    st.bar_chart(df, x='Skills', y='Skill Total')

with col1:
    fetch_and_plot_data('http://api:4000/d/totalstudent', 'Total Student Skill Count')
    fetch_and_plot_data('http://api:4000/d/totaljob', 'Total Job Skill Count')


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
    for skill in uncovered_skills:
        st.write(skill)

    
st.write("Search Jobs")
st.write("Search Courses")
