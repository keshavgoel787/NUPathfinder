########################################################
# Recruiter blueprint of endpoints
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
recruiters = Blueprint('recruiters', __name__)

#Get all the listings for a recruiter
@recruiters.route('/Listings/<rec_Id>', methods=['GET'])
def get_listings(rec_Id):
    query = f'''
        SELECT 
         jobId,
         position, 
         description, 
         startDate,
         endDate 
         from jobs 
         where recID = {str(rec_Id)}
    '''
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response



#Get all the listings for a recruiter
@recruiters.route('/updateJob/<job_Id>', methods=['PUT'])
def updateJob(job_Id):
    job_info = request.json

    position = job_info.get('position')
    description = job_info.get('description')
    startDate = job_info.get('startDate')
    endDate = job_info.get('endDate')

    current_app.logger.info(job_info)

    query = '''
        UPDATE jobs SET 
            position = %s,
            description = %s,
            startDate= %s,
            endDate = %s
            WHERE jobID = %s
    '''
    
    conn = db.get_db()
    cursor = conn.cursor()

    cursor.execute(query, (position, description, startDate, endDate, job_Id))

    conn.commit()

    response = make_response(jsonify({"message": "Job updated successfully"}))
    response.status_code = 200
    return response

#get the best applicants for a job by a recruiter
@recruiters.route('/applicants/<Job_id>', methods={'GET'})
def get_Applicants(Job_id):
    query = f'''
        select s. studentId, s.firstName, s.lastName, s.major, application.matchPercent,
        application.status, application.dateOfApplication from application
            JOIN students s on application.studentID = s.studentID
    where jobID = {str(Job_id)}
    order by matchPercent desc
    LIMIT 10;
    '''
    
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    return jsonify(theData)

#get the skills of a specific student
@recruiters.route('/applicants/skills/<Student_Id>', methods={'GET'})
def get_Applicant_Skills(Student_Id):
    query = f'''
        SELECT firstName, lastName, skills.name, 
        skills.description, skills.category, s.proficiency from skills NATURAL JOIN 
        studentSkills s NATURAL JOIN students where s.studentId = {str(Student_Id)};
    '''
    
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


#add a job to the jobs table in the database
@recruiters.route("/addJob/<rec_Id>", methods = ['POST'])
def addJob(rec_Id):
    the_data = request.json
    current_app.logger.info(the_data)

    position = the_data['position']
    description = the_data['description']
    startDate = the_data['startDate']
    endDate = the_data['endDate']
    recId = rec_Id


    query = '''
        INSERT INTO jobs (position, description, startDate, endDate, recID)

        VALUES (%s, %s, %s, %s, %s);
    '''
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query, (position, description, startDate, endDate, recId))
    db.get_db().commit()
    
    response = make_response("Successfully added job")
    response.status_code = 200
    return response


    #get the skills of a specific student
@recruiters.route('/jobs/skills', methods=['GET'])
def get_Job_Skills():
    query = f'''
        SELECT * from skills;
    '''
    
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

#add a job to the jobs table in the database
@recruiters.route("/addSkillJob", methods = ['POST'])
def addSkillJob():
    the_data = request.json
    current_app.logger.info(the_data)



    jobId = the_data['jobId']
    skillName = the_data['skill']
    skillProficiency = the_data['level']


    query2 = '''
        INSERT INTO jobsSkills (jobID, name, proficiency)
        VALUES
        (%s, %s, %s)
    '''
    current_app.logger.info(query2)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query2, (jobId, skillName, skillProficiency))
    db.get_db().commit()
    
    response = make_response("Successfully added match")
    response.status_code = 200
    return response




@recruiters.route("/addSkill", methods = ['POST'])
def addSkill():
    the_data = request.json
    current_app.logger.info(the_data)

    name = the_data['name']
    description = the_data['description']
    category = the_data['category']


    query = '''
        INSERT INTO skills (name, description, category)

        VALUES (%s, %s, %s);
    '''
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query, (name, description, category))
    db.get_db().commit()
    
    response = make_response("Successfully added skill")
    response.status_code = 200
    return response
@recruiters.route('/deleteJob/<int:jobId>', methods=['DELETE'])
def remove_Job(jobId):
    current_app.logger.info(f"Attempting to delete Job ID: {jobId}")
    try:
        # SQL query with parameterized input
        query = "DELETE FROM jobs WHERE jobId = %s"
        query2 = "DELETE FROM application WHERE jobId = %s"
        query3 = "DELETE FROM experiences WHERE jobId = %s"
        query4 = "DELETE FROM jobsSkills WHERE jobId = %s"

        # Database connection
        conn = db.get_db()
        cursor = conn.cursor()

        # Execute the query
        cursor.execute(query2, (jobId))
        cursor.execute(query3, (jobId))
        cursor.execute(query4, (jobId))
        cursor.execute(query, (jobId))

        # Commit changes
        conn.commit()

        response = make_response("Successfully added skill")
        response.status_code = 200
        return response
    except:
        conn.rollback()
        current_app.logger.error(f"Error deleting Job ID {jobId}: {e}")
        return jsonify({"error": str(e)}), 500