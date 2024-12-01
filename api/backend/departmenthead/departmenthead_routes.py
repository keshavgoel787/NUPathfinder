########################################################
#Department Head blueprint of endpoints
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
departmenthead = Blueprint('departmenthead', __name__)

#Get all the listings for a recruiter
@departmenthead.route('/Gaps', methods=['GET'])
def get_listings():
    query = f'''
        SELECT *
        FROM SkillsGap
    '''
    
    cursor = db.get_db().cursor()

    cursor.execute(query)
    

    theData = cursor.fetchall() 

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@departmenthead.route('/totalstudent', methods = ['GET'])
def get_total_student():
    query = f'''
        SELECT *
        FROM studentSkills
    '''
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@departmenthead.route('/Note/<department_ID>', methods = ['GET','POST'])
def add_note(department_ID):
    if request.method == 'POST':

        the_data = request.json
        current_app.logger.info(the_data)

        content = the_data['content']

        query = '''
        INSERT INTO Notes(userID, content)
        VALUES (%s, %s)
        '''
        current_app.logger.info(query)

        # executing and committing the insert statement 
        cursor = db.get_db().cursor()
        cursor.execute(query, (department_ID, content))
        db.get_db().commit()
    
        response = make_response("Successfully added Note")
        response.status_code = 200
        return response
    
    else:

        query = f'''
        SELECT *
        FROM Notes
        WHERE userID = {department_ID}
        '''
    
        cursor = db.get_db().cursor()

        cursor.execute(query)

        theData = cursor.fetchall() 

        response = make_response(jsonify(theData))
        response.status_code = 200
        return response
    
