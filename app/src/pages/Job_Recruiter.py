import logging
logger = logging.getLogger(__name__)

import streamlit as st

from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()


st.title(f"Welcome Job Recruiter, {st.session_state['rec_id']}.")
st.write('')
st.write('')
st.write('### What would you like to do today?')

if st.button('View Your Current Job Listings', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Listings.py')

if st.button('Add a new job listing', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/AddListing.py')