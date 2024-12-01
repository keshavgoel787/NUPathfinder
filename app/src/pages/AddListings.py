import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
import array
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title(f"Add a new job listing, {st.session_state['first_name']}.")

 with st.form("add_listing_form"):
    
    # Create the various input widgets needed for 
    # each piece of information you're eliciting from the user
    product_name = st.text_input("Job Name")



