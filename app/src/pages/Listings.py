import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Here are your job listings:, {st.session_state['first_name']}.")
st.write('')
st.write('')

url = f"http://api:4000/r/Listings/{st.session_state['rec_id']}"

listings = requests.get(url).json()


df = pd.DataFrame(listings)

st.write(df)
