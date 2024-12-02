import streamlit as st
import requests
import logging
from modules.nav import SideBarLinks

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks(show_home=True)

# Set the page title
st.title("Job Description")

# Base API URL
url = 'http://api:4000/j'

# Check if a job ID is in the session state
if 'selected_job_id' in st.session_state:
    job_id = st.session_state['selected_job_id']
    try:
        # Fetch job details using the API
        response = requests.get(f"{url}/jobs/{job_id}")
        response.raise_for_status()
        job_details = response.json()

        if job_details:
            job = job_details[0]
            st.write("## Job Details")
            st.write(f"**Job Title:** {job['position']}")
            st.write(f"**Company:** {job['name']}")
            st.write(f"**Start Date:** {job['startDate']}")
            st.write(f"**End Date:** {job['endDate']}")
            st.write(f"**Description:** {job['description']}")
        else:
            st.write("Job details not found.")
    except requests.RequestException as err:
        logger.error(f"Error: {err}")
        st.error("Error loading job details.")
else:
    st.write("No job selected. Please go back and select a job from the listings.")
