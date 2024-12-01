import streamlit as st
#import mysql
import mysql.connector
import logging
from modules.nav import SideBarLinks


logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

SideBarLinks(show_home=True)


# Set the page title
st.title("Job Listings")
st.write("\n\n")

# Connect to the MySQL database
def get_db_connection():
    return mysql.connector.connect(
        host="mysql_db",
        user="root",  # replace with your MySQL username
        password="BillyBobJoe",  # replace with your MySQL password
        database="NUPathfinder"
    )

# Search bar for job listings
st.write("### Search for Job Listings")
search_query = st.text_input("Enter a field or keyword to search for job listings")

if st.button('Search', type='primary', use_container_width=True):
    if search_query:
        try:
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)
            # Search for job listings in the database
            query = '''
                SELECT j.jobID, j.position AS title, j.description, j.startDate, j.endDate, c.name AS company
                FROM jobs j
                JOIN Recruiters r ON j.recID = r.recID
                JOIN Companies c ON r.companyID = c.companyID
                WHERE j.position LIKE %s OR j.description LIKE %s
            '''
            cursor.execute(query, (f"%{search_query}%", f"%{search_query}%"))
            job_listings = cursor.fetchall()
            cursor.close()
            conn.close()

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
        except mysql.connector.Error as err:
            logger.error(f"Error: {err}")
            st.error("Error fetching job listings. Please try again later.")
    else:
        st.warning("Please enter a keyword to search for job listings.")

# Display random job listings if no search query is provided
try:
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    # Retrieve all job listings
    query = '''
        SELECT j.jobID, j.position AS title, j.description, j.startDate, j.endDate, c.name AS company
        FROM jobs j
        JOIN Recruiters r ON j.recID = r.recID
        JOIN Companies c ON r.companyID = c.companyID
    '''
    cursor.execute(query)
    job_listings = cursor.fetchall()
    cursor.close()
    conn.close()

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
except mysql.connector.Error as err:
    logger.error(f"Error: {err}")
    st.error("Error loading job listings.")
