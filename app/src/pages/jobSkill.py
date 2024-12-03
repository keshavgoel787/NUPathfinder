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

st.title(f"Add a skill for a job.")
st.write('')
st.write('')

url = f"http://api:4000/r/Listings/{st.session_state['rec_id']}"

listings = requests.get(url).json()

IdArray = []
posArray = []

for i in listings:
    IdArray.append(i['jobId'])
    posArray.append(i['position'])

skills = requests.get("http://api:4000/r/jobs/skills").json()

skillsArray =[]

for i in skills:
    skillsArray.append(i['name'])

with st.form("Add_match_form"):

    jobOption = st.selectbox("Select which job you would like to match a skill to",
    posArray)

    skillOption = st.selectbox("Select which skill you would like to add to this job",
    skillsArray)

    skillLevel= st.selectbox("Add skill level",
    (1, 2, 3, 4, 5))

    submit_button = st.form_submit_button("Add match")

    if submit_button:
        if not jobOption:
            st.error('please select a job')
        if not skillOption:
            st.error('please select a skill')
        if not skillLevel:
            st.error('please add a skill level')
        else:
            match_data = {
                'jobId': IdArray[posArray.index(jobOption)],
                'skill': skillOption,
                'level': skillLevel
            }
            try:
                url2 = f"http://api:4000/r/addSkillJob"
                response = requests.post(url2, json=match_data)
                if response.status_code == 200:
                    st.success("Match added successfully!")
                else:
                    st.error(f"Error adding skill: {response.text}")
            except requests.exceptions.RequestException as e:
                    st.error(f"Error connecting to server: {str(e)}")


st.write("")
st.write("")

if st.button("Or create a new skill", 
    type = 'primary', 
    use_container_width=True):
    st.switch_page('pages/addSkill.py')
        
                    
