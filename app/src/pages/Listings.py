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

st.title(f"Here are your job listings, {st.session_state['first_name']}.")
st.write('')
st.write('')

url = f"http://api:4000/r/Listings/{st.session_state['rec_id']}"

listings = requests.get(url).json()

posArray = []
descArray = []
startDates = []
endDates = []

for i in listings:
    posArray.append(i['position'])
    descArray.append(i['description'])
    startDates.append(i['startDate'][6:17])
    endDates.append(i['endDate'][6:17])

df = pd.DataFrame(
    {
        "Position": posArray,
        "Description": descArray,
        "Start date": startDates,
        "End date": endDates,
    }
)
   

st.dataframe(df, hide_index = True)
