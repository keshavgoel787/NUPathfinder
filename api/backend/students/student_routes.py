########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

import logging
logger = logging.getLogger(__name__)

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
students = Blueprint('students', __name__)

#------------------------------------------------------------
# Get all the students from the database, package them up,
# and return them to the client
# ------------------------------------------------------------
# Get all the job listings from the database
@students.route('/jobs', methods=['GET'])
def get_listings():
    query = '''
        SELECT j.jobID, j.position, j.description, c.name, AVG(e.rating) AS average_rating
        FROM jobs j
        JOIN Recruiters r ON j.recID = r.recID
        JOIN Companies c ON r.companyID = c.companyID
        LEFT JOIN experiences e ON j.jobID = e.jobID
        GROUP BY j.jobID
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get all skills from a student
@students.route('/studentSkills/<studentID>', methods=['GET'])
def get_student_skills(studentID):
    query = '''
        SELECT name, proficiency
        FROM studentSkills
        WHERE studentID = %s
    '''
    current_app.logger.info(f'GET /studentSkills/{studentID} query={query}')
    cursor = db.get_db().cursor()
    cursor.execute(query, (studentID,))
    theData = cursor.fetchall()
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ------------------------------------------------------------
# Add a new skill to a student
@students.route('/studentSkills/<studentID>', methods=['POST'])
def add_new_skill(studentID):
    the_data = request.json
    current_app.logger.info(the_data)

    # Extracting the variables
    name = the_data['skill_name']
    proficiency = the_data['skill_proficiency']

    query = '''
        INSERT INTO studentSkills (studentID, name, proficiency)
        VALUES (%s, %s, %s)
    '''
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query, (studentID, name, proficiency))
    db.get_db().commit()

    response = make_response("Successfully added skill")
    response.status_code = 200
    return response

# ------------------------------------------------------------
# Update a skill for a student
@students.route('/studentSkills/<studentID>/<skill_name>', methods=['PUT'])
def update_skill(studentID, skill_name):
    skill_info = request.json
    current_app.logger.info(skill_info)

    # Extracting variables to update
    proficiency = skill_info.get('proficiency', None)

    # Ensure proficiency is provided
    if proficiency is None:
        response = make_response("Missing 'proficiency' field in request data")
        response.status_code = 400
        return response

    query = '''
        UPDATE studentSkills
        SET proficiency = %s
        WHERE studentID = %s AND name = %s
    '''
    current_app.logger.info(f"Executing query: {query} with values ({proficiency}, {studentID}, {skill_name})")
    cursor = db.get_db().cursor()
    cursor.execute(query, (proficiency, studentID, skill_name))
    db.get_db().commit()

    # Check if any rows were updated
    if cursor.rowcount == 0:
        response = make_response("No skill found to update")
        response.status_code = 404
    else:
        response = make_response("Successfully updated skill")
        response.status_code = 200

    return response

# ------------------------------------------------------------
# Delete a skill from a student
@students.route('/studentSkills/<student_id>/<skill_name>', methods=['DELETE'])
def delete_skill(student_id, skill_name):
    current_app.logger.info(f'Deleting skill for student {student_id} with name {skill_name}')
    
    query = '''
        DELETE FROM studentSkills
        WHERE studentID = %s AND name = %s
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query, (student_id, skill_name))
    db.get_db().commit()

    response = make_response(f"Successfully deleted skill for student {student_id} with name {skill_name}")
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get reviews of a job listing
@students.route('/reviews/<jobID>', methods=['GET'])
def get_reviews(jobID):
    query = '''
        SELECT title, username, review, rating
        FROM experiences
        WHERE jobID = %s
    '''
    current_app.logger.info(f'GET /reviews/{jobID} query={query}')
    cursor = db.get_db().cursor()
    cursor.execute(query, (jobID,))
    theData = cursor.fetchall()
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


@students.route('/reviews/<Username>/<jobID>', methods=['POST'])
def add_review(Username, jobID):
    the_data = request.json
    current_app.logger.info(f"Received review data: {the_data}")

    try:
        # Extracting the variables
        title = the_data['title']
        review = the_data['review']
        rating = the_data['rating']
        cursor = db.get_db().cursor()

        # Insert a new review
        query = '''
            INSERT INTO experiences (title, Username, review, rating, jobID)
            VALUES (%s, %s, %s, %s, %s)
        '''
        cursor.execute(query, (title, Username, review, rating, jobID))
        current_app.logger.info(f"Inserted new review for student_id={Username}, jobID={jobID}")

        db.get_db().commit()
        response = make_response("Successfully added/updated review")
        response.status_code = 200

    except Exception as e:
        current_app.logger.error(f"Error occurred while adding/updating review: {e}")
        db.get_db().rollback()  # Roll back the transaction in case of error
        response = make_response(f"Failed to add/update review: {str(e)}")
        response.status_code = 500

    return response

#
# Add a new application for a student
@students.route('/application/<studentID>', methods=['POST'])
def submit_application(studentID):
    the_data = request.json
    current_app.logger.info(f"Received application data: {the_data}")

    try:
        # Extracting the variables from the input data
        jobID = the_data.get('jobID')
        status = the_data.get('status', 'Submitted')
        date_of_application = the_data.get('dateOfApplication')  # Default to a specific date if not provided

        # Ensure all necessary fields are present
        if not jobID:
            raise ValueError("Missing required field: jobID.")

        # Insert a new application into the application table
        query = '''
            INSERT INTO application (studentID, jobID, dateOfApplication, status)
            VALUES (%s, %s, %s, %s)
        '''
        cursor = db.get_db().cursor()
        current_app.logger.info(f"Executing query: {query} with values ({studentID}, {jobID}, {date_of_application}, {status})")
        cursor.execute(query, (studentID, jobID, date_of_application, status))
        db.get_db().commit()

        current_app.logger.info(f"Inserted new application for studentID={studentID}, jobID={jobID}")
        response = make_response("Successfully submitted application")
        response.status_code = 200

    except ValueError as ve:
        current_app.logger.error(f"Validation error: {ve}")
        response = make_response(f"Validation error: {str(ve)}")
        response.status_code = 400

    except Exception as e:
        current_app.logger.error(f"Error occurred while submitting application: {e}")
        db.get_db().rollback()  # Roll back the transaction in case of error
        response = make_response(f"Failed to submit application: {str(e)}")
        response.status_code = 500

    return response
