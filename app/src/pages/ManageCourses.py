import streamlit as st
import requests
import logging
import pandas as pd
from modules.nav import SideBarLinks

# Set up logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Sidebar
SideBarLinks()

# Set the page title
st.title("Course List")
st.write("\n\n")

# Get department ID (default to 1 if not set)
department_id = st.session_state.get('department_ID', 1)

# Fetch course data
try:
    course_data = requests.get(f'http://api:4000/d/course/{department_id}')
    course_data.raise_for_status()
    course_data = course_data.json()
except requests.exceptions.RequestException as e:
    st.error("Failed to fetch course data.")
    logger.error(f"Error fetching course data: {e}")
    st.stop()

# Transform course data into a DataFrame
df = pd.DataFrame(course_data)
if not df.empty:
    df.rename(columns={
        'courseID': 'Course Num',
        'departmentID': 'Department Num',
        'name': 'Course Name',
        'description': 'Course Description',
    }, inplace=True)

# Display list of courses
st.subheader('List of Courses')
for index, row in df.iterrows():
    with st.expander(f"{row['Course Name']}"):
        st.write(f"**Description**: {row['Course Description']}")

        skill_request = requests.get(f'http://api:4000/d/courseskills/{row["Course Num"]}').json()

        if skill_request:
            st.write("----")
            st.write("**Skills**")
            for i in skill_request:
                st.write(i['name'])

            st.write("----")

        else:

            st.write("No Skills Associated")

        # Action buttons
        col1, col2, col3 = st.columns(3)

        
        # Delete course button
        with col1:
            if st.button("Delete Course", key=f"delete{row['Course Num']}"):
                try:
                    response = requests.delete(f"http://api:4000/d/deletecourse/{department_id}/{row['Course Num']}")
                    response.raise_for_status()
                    st.success(f"Successfully deleted {row['Course Name']}.")
                    st.rerun()
                except requests.exceptions.RequestException as e:
                    st.error("Failed to delete the course.")
                    logger.error(f"Error deleting course {row['Course Num']}: {e}")

        # Update skill button (currently does nothing)
        with col2:
            if st.button("Update Skills", key=f"edit{row['Course Num']}"):
                st.session_state['Current Course #'] = row['Course Num']
                st.session_state['Current Course'] = row['Course Name']
                st.switch_page("pages/CourseSkill.py")
        
        with col3:
            if st.button("Update Course Info", key=f"change{row['Course Num']}"):
                st.session_state['Current Course #'] = row['Course Num']
                st.session_state['Current Course'] = row['Course Name']
                st.switch_page("pages/CourseDesc.py")

# Button to add a new course
if st.button("Add New Course"):
    st.switch_page("pages/AddCourse.py")