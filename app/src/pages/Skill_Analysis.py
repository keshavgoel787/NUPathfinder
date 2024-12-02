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

department_id = st.session_state.get('department_ID', 1)

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

skill_gaps = requests.get('http://api:4000/d/Gaps').json()

st.subheader('Skill Gaps to Address')
if len(skill_gaps)<1:
    st.write("No Skill Gaps to Address")
else:
    for i in skill_gaps:
        st.write(i['name'])
