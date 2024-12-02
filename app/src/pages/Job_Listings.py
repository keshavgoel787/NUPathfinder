import streamlit as st
import requests
import logging
from modules.nav import SideBarLinks

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks(show_home=True)

# Set the page title
st.title("Job Listings")
st.write("\n\n")

# Base API URL
url = 'http://api:4000/s'

# Search bar for job listings
st.write("### Search for Job Listings")
search_query = st.text_input("Enter a field or keyword to search for job listings")

if st.button('Search', type='primary', use_container_width=True):
    if search_query:
        try:
            # Search for job listings using the API
            response = requests.get(f"{url}/jobs", params={"query": search_query})
            response.raise_for_status()
            job_listings = response.json()

            if job_listings:
                st.write("### Search Results")
                for job in job_listings:
                    st.write(f"Job Title: {job['title']}")
                    st.write(f"Company: {job['company']}")
                    st.write(f"Start Date: {job['startDate']}")
                    st.write(f"End Date: {job['endDate']}")
                    st.write(f"Description: {job['description']}")
                    st.write("---")
            else:
                st.write("No job listings found for the given search query.")
        except requests.RequestException as err:
            logger.error(f"Error: {err}")
            st.error("Error fetching job listings. Please try again later.")
    else:
        st.warning("Please enter a keyword to search for job listings.")

# Display random job listings if no search query is provided
try:
    response = requests.get(f"{url}/jobs")
    response.raise_for_status()
    job_listings = response.json()

    if job_listings:
        st.write("### Random Job Listings")
        for job in job_listings:
            st.write(f"Job Title: {job['title']}")
            st.write(f"Company: {job['company']}")
            st.write(f"Start Date: {job['startDate']}")
            st.write(f"End Date: {job['endDate']}")
            st.write(f"Description: {job['description']}")
            st.write("---")
    else:
        st.write("No job listings available at the moment.")
except requests.RequestException as err:
    logger.error(f"Error: {err}")
    st.error("Error loading job listings.")
