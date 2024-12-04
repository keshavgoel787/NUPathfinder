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

st.title(f"Update a skill for {st.session_state['Current Course']}")

courseid = st.session_state['Current Course #']
department_id = st.session_state.get('department_ID', 1)

st.write(courseid)