import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Here are your job listings:, {st.session_state['rec_id']}.")
st.write('')
st.write('')

url = f"http://localhost:8501/r/listings/{st.session_state['rec_id']}"

listings:pd.DataFrame = requests.get(url)
st.dataframe(listings)




if st.button('Add another', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/AddListing.py')
