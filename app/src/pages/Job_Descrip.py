import streamlit as st
import requests
import logging
from modules.nav import SideBarLinks
import math

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks(show_home=True)

# Set the page title
st.title("Job Description")

# Base API URL
urlJ = 'http://api:4000/j'
urlS = 'http://api:4000/s'

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

# Check if a job ID is in the session state
if 'selected_job_id' in st.session_state:
    job_id = st.session_state['selected_job_id']
    try:
        # Fetch job details using the API
        response = requests.get(f"{urlJ}/jobs/{job_id}")
        response.raise_for_status()
        job_details = response.json()

        if job_details:
            job = job_details[0]
            st.write(f"**Job Title:** {job['position']}")
            if 'average_rating' in job and job['average_rating'] is not None:
                st.write(f"Average Rating: {display_stars(job['average_rating'])}")
            st.write(f"**Company:** {job['name']}")
            st.write(f"**Start Date:** {job['startDate']}")
            st.write(f"**End Date:** {job['endDate']}")
            st.write(f"**Description:** {job['description']}")
            st.write("**Required Skills and Proficiency:**")
            skills = job_details
            for skill in skills:
                st.write(f"- {skill['name']}: Proficiency {skill['proficiency']}")

            # Fetch job reviews using the correct API route
            response = requests.get(f"{urlS}/reviews/{job_id}")
            response.raise_for_status()
            reviews = response.json()

            if reviews:
                st.write("---")
                st.write("### Job Reviews")
                for review in reviews:
                    st.write(f"**Title:** {review['title']}")
                    st.write(f"**ID:** {review['username']}")
                    st.write(f"**Review:** {review['review']}")
                    st.write(f"**Rating:** {display_stars(review['rating'])}")
                    st.write("---")
            else:
                st.write("No reviews available for this job.")
            
            # Add a button for adding a new review
            st.write("### Write a Review")
            with st.form("review_form", clear_on_submit=True):
                st.write("#### Add Your Review")
                review_title = st.text_input("Review Title")
                review_text = st.text_area("Review")
                review_rating = st.slider("Rating (1-5)", 1, 5, 1)
                submit_review = st.form_submit_button("Submit Review")

                if submit_review:
                    # Collect data and make POST request to add the review
                    review_data = {
                        "title": review_title,
                        "review": review_text,
                        "rating": review_rating
                    }
                    try:
                        Username = st.session_state.get('student_id', 1)  # Replace with actual student ID logic
                        response = requests.post(f"{urlS}/reviews/{Username}/{job_id}", json=review_data)
                        if response.status_code == 200:
                            st.success("Review added successfully.")
                        else:
                            st.error(f"Failed to add review. Server responded with: {response.text}")
                    except requests.RequestException as err:
                        logger.error(f"Error: {err}")
                        st.error("Failed to add review. Please try again later.")
    except requests.RequestException as err:
        logger.error(f"Error: {err}")
        st.error("Error loading job details or reviews.")
else:
    st.write("No job selected. Please go back and select a job from the listings.")
