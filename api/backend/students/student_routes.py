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
        SELECT jobID, position, startDate, endDate, description
        FROM jobs
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ------------------------------------------------------------
# Get specific listing details by ID
@students.route('/jobs/<id>', methods=['GET'])
def get_listing_detail(id):
    query = '''
        SELECT jobID, position, startDate, endDate, description
        FROM jobs
        WHERE jobID = %s
    '''
    current_app.logger.info(f'GET /listing/<id> query={query}')
    cursor = db.get_db().cursor()
    cursor.execute(query, (id,))
    theData = cursor.fetchall()

    current_app.logger.info(f'GET /listing/<id> Result of query = {theData}')
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ------------------------------------------------------------
# Add a new skill to a student
@students.route('/studentSkills/<studentID>', methods=['POST'])
def add_new_skill():
    the_data = request.json
    current_app.logger.info(the_data)

    # Extracting the variables
    name = the_data['skill_name']
    student_ID = the_data['student_id']
    proficiency = the_data['skill_proficiency']

    query = '''
        INSERT INTO studentSkills (studentID, name, proficiency)
        VALUES (%s, %s, %s)
    '''
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query, (student_ID, name, proficiency))
    db.get_db().commit()

    response = make_response("Successfully added skill")
    response.status_code = 200
    return response

# ------------------------------------------------------------
# Update a skill for a student
@students.route('/studentSkills/<studentID>/<skill_name>', methods=['PUT'])
def update_skill(studentID,skill_name):
    skill_info = request.json
    current_app.logger.info(skill_info)

    # Extracting variables to update
    proficiency = skill_info.get('proficiency', None)

    query = '''
        UPDATE studentSkills
        SET proficiency = %s
        WHERE studentID = %s AND name = %s
    '''
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    skill_name = skill_info.get('skill_name')
    cursor.execute(query, (proficiency, studentID, skill_name))
    db.get_db().commit()

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

