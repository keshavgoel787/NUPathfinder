import streamlit as st
import requests
import logging
from modules.nav import SideBarLinks
import streamlit.components.v1 as components
import math
from datetime import date

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

def display_stars(rating):
    """
    Function to display stars for the rating.
    """
    full_stars = math.floor(float(rating))
    half_star = float(rating) - full_stars >= 0.5
    stars = "★" * full_stars
    if half_star:
        stars += "⯯"  # Use a half star symbol if desired
    return stars

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
                    st.write(f"Job Title: {job['position']}")
                    st.write(f"Company: {job['name']}")
                    st.write(f"Description: {job['description']}")
                    if 'average_rating' in job and job['average_rating'] is not None:
                        st.write(f"Average Rating: {display_stars(job['average_rating'])}")
                    if st.button(f"View Details: {job['position']}", key=f"search_{job['jobID']}"):
                        st.session_state['selected_job_id'] = job['jobID']
                        st.switch_page('pages/Job_Descrip.py')
                    # Add a button for submitting an application
                st.write("### Submit Your Application")
                if st.button("Submit Application", key=f"submit_application_{job['jobID']}"):
                    student_id = st.session_state.get('student_id', 1)  # Replace with actual student ID logic
                    application_data = {
                        "jobID": job['jobID'],
                        "status": "Submitted",
                        "dateOfApplication": date.today().isoformat()  # Replace with current date logic
                    }
                    try:
                        response = requests.post(f"{url}/application/{student_id}", json=application_data)
                        if response.status_code == 200:
                            st.success("Application submitted successfully.")
                        else:
                            st.error(f"Failed to submit application. Server responded with: {response.text}")
                    except requests.RequestException as err:
                        logger.error(f"Error: {err}")
                        st.error("Failed to submit application. Please try again later.")
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
            st.write(f"Job Title: {job['position']}")
            st.write(f"Company: {job['name']}")
            st.write(f"Description: {job['description']}")
            if 'average_rating' in job and job['average_rating'] is not None:
                st.write(f"Average Rating: {display_stars(job['average_rating'])}")
            if st.button(f"View Details: {job['position']}", key=job['jobID']):
                st.session_state['selected_job_id'] = job['jobID']
                st.switch_page('pages/Job_Descrip.py')

                # Add a button for submitting an application
            if st.button("Submit Application", key=f"submit_application_{job['jobID']}"):
                student_id = st.session_state.get('student_id', 1)  # Replace with actual student ID logic
                application_data = {
                    "jobID": job['jobID'],
                    "status": "Submitted",
                    "dateOfApplication": date.today().isoformat()  # Replace with current date logic
                }
                try:
                    response = requests.post(f"{url}/application/{student_id}", json=application_data)
                    if response.status_code == 200:
                        st.success("Application submitted successfully.")
                    else:
                        st.error(f"Failed to submit application. Server responded with: {response.text}")
                except requests.RequestException as err:
                    logger.error(f"Error: {err}")
                    st.error("Failed to submit application. Please try again later.")
            st.write("---")

    else:
        st.write("No job listings available at the moment.")
except requests.RequestException as err:
    logger.error(f"Error: {err}")
    st.error("Error loading job listings.")
