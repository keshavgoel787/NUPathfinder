import logging
logger = logging.getLogger(__name__)

import streamlit as st

from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()


st.title(f"Welcome Department Head, {st.session_state['department_ID']}.")
st.write('')
st.write('')
st.write('### What would you like to do today?')

if st.button('View Skill Gaps', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Skill_Analysis.py')

if st.button('Add a Note', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Skill_Analysis.py')