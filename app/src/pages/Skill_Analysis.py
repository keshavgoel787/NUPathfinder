import streamlit as st
import requests
import logging
import pandas as pd
import matplotlib.pyplot as plt
from modules.nav import SideBarLinks
from collections import defaultdict

# Configure logging for debugging and information tracking
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize the sidebar with navigation links
SideBarLinks(show_home=True)

# Set the page title
st.title("Skill Analysis")
st.write("\n\n")

# Create two columns for displaying data
col1, col2 = st.columns(2)

# Retrieve session variables with fallback defaults
department_id = st.session_state.get('department_ID', 1)
s_id = st.session_state.get('student_id', 1)
rec_id = st.session_state.get('rec_id', 1)

# Display Student Skill Count in the first column
with col1:
    try:
        student_data = requests.get('http://api:4000/d/totalstudent').json()
        df_s = pd.DataFrame(student_data)
        df_s.rename(columns={'name': 'Skills', 'total': '# of Students with Skill'}, inplace=True)
        st.subheader('Student Skill Count')
        st.bar_chart(df_s, x='Skills', y='# of Students with Skill')
    except Exception as e:
        logger.error(f"Error fetching or processing student data: {e}")
        st.error("Failed to load student skill data.")

# Display Job Skill Count in the second column
with col2:
    try:
        job_data = requests.get('http://api:4000/d/totaljob').json()
        df_j = pd.DataFrame(job_data)
        df_j.rename(columns={'name': 'Skills', 'total': '# of Jobs that Request Skill'}, inplace=True)
        st.subheader('Job Skill Count')
        st.bar_chart(df_j, x='Skills', y='# of Jobs that Request Skill')
    except Exception as e:
        logger.error(f"Error fetching or processing job data: {e}")
        st.error("Failed to load job skill data.")

# Fetch proficiency data for comparison
try:
    proficiency_data = {
        "student_skills": requests.get('http://api:4000/s/allstudentskills').json(),
        "job_skills": requests.get('http://api:4000/r/jobskills').json(),
    }

    # Prepare data for comparison between job and student proficiencies
    proficiency_comparison = []
    for job_skill in proficiency_data['job_skills']:
        skill_name = job_skill['name']
        job_proficiency = job_skill['proficiency']
        student_proficiency_data = [s['proficiency'] for s in proficiency_data['student_skills'] if s['name'] == skill_name]
        avg_student_proficiency = sum(student_proficiency_data) / len(student_proficiency_data) if student_proficiency_data else 0
        proficiency_comparison.append({
            "Skill": skill_name,
            "Job Proficiency": job_proficiency,
            "Avg Student Proficiency": avg_student_proficiency
        })


    job_skills_aggregated = defaultdict(list)
    for job_skill in proficiency_data['job_skills']:
        job_skills_aggregated[job_skill['name']].append(job_skill['proficiency'])

    aggregated_job_skills = []
    for skill, proficiencies in job_skills_aggregated.items():
        aggregated_job_skills.append({
            "name": skill,
            "proficiency": sum(proficiencies) / len(proficiencies)  # Average proficiency
        })
    
    df_proficiency = pd.DataFrame(proficiency_comparison).drop_duplicates(subset=["Skill"])



    # Plot the comparison graph
    st.subheader("Proficiency Comparison Between Job and Student Skills")
    fig, ax = plt.subplots(figsize=(10, 6))
    width = 0.35  # Bar width

    # Plot bars for job and student proficiencies
    x = range(len(df_proficiency))
    ax.bar(x, df_proficiency["Job Proficiency"], width, label="Job Proficiency")
    ax.bar([pos + width for pos in x], df_proficiency["Avg Student Proficiency"], width, label="Avg Student Proficiency")

    # Customize the graph
    ax.set_xlabel("Skills")
    ax.set_ylabel("Proficiency")
    ax.set_title("Comparison of Job vs. Student Skill Proficiency")
    ax.set_xticks([pos + width / 2 for pos in x])
    ax.set_xticklabels(df_proficiency["Skill"], rotation=45, ha="right")
    ax.legend()

    # Display the graph
    st.pyplot(fig)
except Exception as e:
    logger.error(f"Error fetching or processing proficiency data: {e}")
    st.error("Failed to load proficiency comparison data.")

# Create three columns for skill gaps and course recommendations
col3, col4, col5 = st.columns(3)

try:
    # Fetch data for skill gaps and recommended courses
    skill_gaps = requests.get('http://api:4000/d/Gaps').json()
    courses = requests.get('http://api:4000/d/course/recommend').json()

    with col3:
        # Display skill gaps
        st.subheader('Skill Gaps to Address')
        skills = {i['skill_name'] for i in skill_gaps}  # Extract unique skills
        for skill in skills:
            st.write(skill)

    with col4:
        # Display recommended courses
        st.subheader('Courses to Recommend Students:')
        course_skills = {i['skill_name']: i['name'] for i in courses}  # Map skill names to course names
        for skill, course in course_skills.items():
            st.write(f"Course: {course} | Skill: {skill}")

    with col5:
        # Identify and display uncovered skills
        st.subheader('Recommended Course Topics')
        uncovered_skills = skills - course_skills.keys()  # Skills not covered by courses
        if uncovered_skills:
            for skill in uncovered_skills:
                st.write(skill)
        else:
            st.write('All Skills Accounted For!')

except Exception as e:
    logger.error(f"Error fetching or processing skill gap/course data: {e}")
    st.error("Failed to load skill gap or course recommendation data.")

# Button to navigate to the course management page
if st.button('Manage Current Courses', type='primary', use_container_width=True):
    st.switch_page('pages/ManageCourses.py')
