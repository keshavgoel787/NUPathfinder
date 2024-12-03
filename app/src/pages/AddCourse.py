import logging
logger = logging.getLogger(__name__)

import pandas as pd
import streamlit as st
import requests
import array
import datetime
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title(f"Add a new job listing, {st.session_state['first_name']}.")


with st.form("add_listing_form"):
    
    

    # Create the various input widgets needed for 
    # each piece of information you're eliciting from the user
    Listing_name = st.text_input("Job Position")
    Listing_description = st.text_area(("Job description"))
    Listing_startDate = st.date_input(
        "Select the job's start date: ",
        format = "YYYY-MM-DD",
    )
    Listing_endDate = st.date_input(
        "Select the job's end date: ",
        format = "YYYY-MM-DD",
    )

    submit_button = st.form_submit_button("Add job")

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
            
            # Now, we try to make a POST request to the proper end point
            try:
                url = f"http://api:4000/r/addJob/{st.session_state['rec_id']}"
                response = requests.post(url, json=listing_data)
                if response.status_code == 200:
                    st.success("listing added successfully!")
                else:
                    st.error(f"Error adding listing: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")
        



