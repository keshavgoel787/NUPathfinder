########################################################
# Recruiter blueprint of endpoints
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
recruiters = Blueprint('recruiters', __name__)


#Get all the listings for a recruiter
@recruiters.route('/Listings/<rec_Id>', methods=['GET'])
def get_listings(rec_Id):
    query = f'''
        SELECT 
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
    LIMIT 5;
    '''
    
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

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

