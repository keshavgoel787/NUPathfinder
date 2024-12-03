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



if listings:
    for i in listings:
        st.write(f"Position: {i['position']}")
        st.write(f"Description: {i['description']}")
        st.write(f"Start date: {i['startDate'][6:17]}")
        st.write(f"end date: {i['endDate'][6:17]}")
        if st.button("View applicants", key=f"view{i['jobId']}"):
            st.session_state['applicant_job_id'] = i['jobId']
            st.session_state['applicant_job_name'] = i['position']
            st.switch_page('pages/viewApplicants.py')

        st.write("---")
    else:
         if st.button("Add another one"):
            st.session_state['recState'] = 'adding'
            st.switch_page('pages/AddListings.py')

else:
    st.write('You do not currently have any listings')
    if st.button("Add one now!"):
        st.session_state['recState'] = 'adding'
        st.switch_page('pages/AddListings.py')



# df = pd.DataFrame(
#     {
#         "Position": posArray,
#         "Description": descArray,
#         "Start date": startDates,
#         "End date": endDates,
#     }
# )
   
# st.dataframe(df, hide_index = True)

        




