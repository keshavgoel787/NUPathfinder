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
        col1, col2 = st.columns(2)

        with col1: 
            if st.button("View applicants", key=f"view{i['jobId']}"):
                st.session_state['applicant_job_id'] = i['jobId']
                st.session_state['applicant_job_name'] = i['position']
                st.switch_page('pages/viewApplicants.py')
        with col2: 
            if st.button("Edit Listing", key=f"edit{i['jobId']}"):
                st.session_state['Edit_job_id'] = i['jobId']
                st.session_state['Edit_job_desc'] = i['description']
                st.session_state['Edit_job_startDate'] = i['startDate']
                st.session_state['Edit_job_endDate'] = i['endDate']
                st.session_state['Edit_job_name'] = i['position']
                st.switch_page('pages/EditListing.py')
        # if "confirm" not in st.session_state:
        #     st.session_state["confirm"] = False
        # with col3:
        #     if st.button("Remvoe Listing" key=f"remove{i['jobId']}") and not st.session_state["confirm"]:
        #          st.warning("Are you sure you want to perform this action?")
        #          if st.button("Yes, I'm sure"):
        #             st.session_state["confirm"] = True
        #             requests.delete(f"http://api:4000/r/deleteJob/{i['jobId']}")
        #         elif st.session_state["confirm"]:
        #             st.success("Listing has been removed!")


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







