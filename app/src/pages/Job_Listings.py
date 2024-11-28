import streamlit as st
import requests
import logging

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Set the page title
st.title("Job Listings")
st.write("\n\n")

# Search bar for job listings
st.write("### Search for Job Listings")
search_query = st.text_input("Enter a field or keyword to search for job listings")

if st.button('Search', type='primary', use_container_width=True):
    if search_query:
        # Make a GET request to search for job listings based on the search query
        response = requests.get(f'http://localhost:5000/job_listings?search={search_query}')
        if response.status_code == 200:
            job_listings = response.json()
            if job_listings:
                st.write("### Search Results")
                for job in job_listings:
                    st.write(f"Job Title: {job['title']}")
                    st.write(f"Company: {job['company']}")
                    st.write(f"Location: {job['location']}")
                    st.write(f"Description: {job['description']}")
                    st.write("---")
            else:
                st.write("No job listings found for the given search query.")
        else:
            st.error("Error fetching job listings. Please try again later.")
    else:
        st.warning("Please enter a keyword to search for job listings.")

# Display random job listings if no search query is provided
response = requests.get(f'http://localhost:5000/job_listings')

if response.status_code == 200:
    job_listings = response.json()
    if job_listings:
        st.write("### Random Job Listings")
        for job in job_listings:
            st.write(f"Job Title: {job['title']}")
            st.write(f"Company: {job['company']}")
            st.write(f"Location: {job['location']}")
            st.write(f"Description: {job['description']}")
            st.write("---")
    else:
        st.write("No job listings available at the moment.")
else:
    st.error("Error loading job listings.")
