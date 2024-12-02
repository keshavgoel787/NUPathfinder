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

#get the best applicants for a job by a recruiter
@recruiters.route('/applicants/<Job_id>', methods={'GET'})
def get_Applicants(Job_id):
    query = f'''
        select s.firstName, s.lastName, s.major, application.matchPercent,
        application.status, application.dateOfApplication from application
            JOIN students s on application.studentID = s.studentID
    where jobID = {str(Job_id)}
    order by matchPercent desc
    LIMIT 10;
    '''
    
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    # response = make_response(theData)
    # response.status_code = 200
    # response.mimetype='application/json'

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