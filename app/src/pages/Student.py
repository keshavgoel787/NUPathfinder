import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')
st.session_state['authenticated'] = True

SideBarLinks(show_home=True)

logger.info("Loading the Home page of the app")
st.title('Student')
st.write('\n\n')

if st.button('My Profile', 
            type = 'primary', 
            use_container_width=True):
    st.switch_page('pages/Profile.py')

if st.button('Job Listings', 
            type = 'primary', 
            use_container_width=True):
    st.switch_page('pages/Job_Listings.py')