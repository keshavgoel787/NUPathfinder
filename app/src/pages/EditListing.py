import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
import array
from datetime import datetime
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title(f"Edit: {st.session_state['Edit_job_name']}.")


# Original string
date_string1 = st.session_state['Edit_job_startDate']
date_string2 = st.session_state['Edit_job_endDate']

# Convert to datetime object
datetime_obj1 = datetime.strptime(date_string1, "%a, %d %b %Y %H:%M:%S %Z")
datetime_obj2 = datetime.strptime(date_string2, "%a, %d %b %Y %H:%M:%S %Z")


# Extract just the date for Streamlit
sD = datetime_obj1.date()
eD = datetime_obj2.date()



with st.form("add_listing_form"):
    
    # Create the various input widgets needed for 
    # each piece of information you're eliciting from the user
    Listing_name = st.text_input(label="Job Position", value=st.session_state['Edit_job_name'])
    Listing_description = st.text_area(label="Job description", value=st.session_state['Edit_job_desc'])
    Listing_startDate = st.date_input(
        "Select the job's start date: ",
        format = "YYYY-MM-DD",
        value = sD
    )
    Listing_endDate = st.date_input(
        "Select the job's end date: ",
        format = "YYYY-MM-DD",
        value = eD
    )

    submit_button = st.form_submit_button("Edit job")

    if submit_button:
        if not Listing_name:
            st.error("Please enter a job position")
        elif not Listing_description:
            st.error("Please enter a job description")
        elif not Listing_startDate:
            st.error("Please enter a job start date")
        elif not Listing_endDate:
            st.error("Please enter a job end date")
        else:
            # We only get into this else clause if all the input fields have something 
            # in them. 
            #
            # Package the data up that the user entered into 
            # a dictionary (which is just like JSON in this case)
            listing_data = {
                "position": Listing_name,
                "description": Listing_description,
                "startDate": Listing_startDate.strftime("%Y-%m-%d"),
                "endDate": Listing_endDate.strftime("%Y-%m-%d")
            }

            logger.info(f"Listing form submitted with data: {listing_data}")
            
            
            try:
                url = f"http://api:4000/r/updateJob/{st.session_state['Edit_job_id']}"
                response = requests.put(url, json=listing_data)
                if response.status_code == 200:
                    st.success("listing edited successfully!")
                else:
                    st.error(f"Error editing listing: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")
        