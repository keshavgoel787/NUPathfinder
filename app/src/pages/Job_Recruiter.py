import logging
logger = logging.getLogger(__name__)

import streamlit as st

from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()


st.title(f"Welcome Job Recruiter, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### What would you like to do today?')

if st.button('View Your Current Job Listings',   
             type='primary',
             use_container_width=True):
  st.session_state['recState'] = 'listing'
  st.switch_page('pages/Listings.py')

if st.button('Add a new job listing',
             type='primary',
             use_container_width=True): 
  st.session_state['recState'] = 'adding'
  st.switch_page('pages/AddListings.py')

if st.button('Match jobs and skills',   
             type='primary',
             use_container_width=True):
  st.session_state['recState'] = 'adding'
  st.switch_page('pages/jobSkill.py')