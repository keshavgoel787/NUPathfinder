import streamlit as st
#import mysql.connector
import mysql
import logging
import os

logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Set the page title
st.title("My Profile")
st.write("\n\n")

# Connect to the MySQL database
def get_db_connection():
    return mysql.connector.connect(
        host= os.getenv('DB_HOST').strip(),
        user= os.getenv('DB_USER').strip(),  # replace with your MySQL username
        password= os.getenv('MYSQL_ROOT_PASSWORD').strip(),  # replace with your MySQL password
        database="NUPathfinder"
    )

# Display existing skills
student_id = st.session_state.get('student_id', 1)  # Example of retrieving student ID from session state
try:
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    # Retrieve student's skills from the database
    query = '''
        SELECT ss.name AS skill_name, ss.proficiency, s.description
        FROM studentSkills ss
        JOIN skills s ON ss.name = s.name
        WHERE ss.studentID = %s
    '''
    cursor.execute(query, (student_id,))
    skills = cursor.fetchall()
    cursor.close()
    conn.close()

    if skills:
        st.write("### Current Skills")
        for skill in skills:
            st.write(f"Skill: {skill['skill_name']}, Proficiency: {skill['proficiency']}")
            st.write(f"Description: {skill['description']}")
    else:
        st.write("You currently have no skills listed.")
except mysql.connector.Error as err:
    logger.error(f"Error: {err}")
    st.error("Error loading skills.")

st.write("\n\n")

# Add a new skill
st.write("### Add a New Skill")
skill_name = st.text_input("Skill Name")
skill_proficiency = st.slider("Proficiency (1-5)", 1, 5, 1)

if st.button('Add Skill', type='primary', use_container_width=True):
    if skill_name:
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            query = '''
                INSERT INTO studentSkills (studentID, name, proficiency)
                VALUES (%s, %s, %s)
            '''
            cursor.execute(query, (student_id, skill_name, skill_proficiency))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Successfully added skill.")
            st.experimental_rerun()
        except mysql.connector.Error as err:
            logger.error(f"Error: {err}")
            st.error("Failed to add skill.")
    else:
        st.warning("Please enter a skill name.")

# Update skill proficiency
st.write("### Update Skill Proficiency")
skill_to_update = st.selectbox("Select Skill to Update", [skill['skill_name'] for skill in skills] if skills else [])
new_proficiency = st.slider("New Proficiency (1-5)", 1, 5, 1, key='update')

if st.button('Update Skill', type='primary', use_container_width=True):
    if skill_to_update:
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            query = '''
                UPDATE studentSkills
                SET proficiency = %s
                WHERE studentID = %s AND name = %s
            '''
            cursor.execute(query, (new_proficiency, student_id, skill_to_update))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Successfully updated skill proficiency.")
            st.experimental_rerun()
        except mysql.connector.Error as err:
            logger.error(f"Error: {err}")
            st.error("Failed to update skill.")
    else:
        st.warning("Please select a skill to update.")

# Delete a skill
st.write("### Delete a Skill")
skill_to_delete = st.selectbox("Select Skill to Delete", [skill['skill_name'] for skill in skills] if skills else [], key='delete')

if st.button('Delete Skill', type='primary', use_container_width=True):
    if skill_to_delete:
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            query = '''
                DELETE FROM studentSkills
                WHERE studentID = %s AND name = %s
            '''
            cursor.execute(query, (student_id, skill_to_delete))
            conn.commit()
            cursor.close()
            conn.close()
            st.success("Successfully deleted skill.")
            st.experimental_rerun()
        except mysql.connector.Error as err:
            logger.error(f"Error: {err}")
            st.error("Failed to delete skill.")
    else:
        st.warning("Please select a skill to delete.")
