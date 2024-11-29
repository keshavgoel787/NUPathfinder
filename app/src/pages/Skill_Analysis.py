import streamlit as st
import requests
import logging

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Set the page title
st.title("Skill Analysis")
st.write("\n\n")

skill_gaps = requests.get('http://api:4000/d/Gaps').json()

st.subheader('Skill Gaps to Address')
for i in skill_gaps:
    st.write(i['name'])