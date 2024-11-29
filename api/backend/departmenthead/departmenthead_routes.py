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
@departmenthead.route('/', methods=['GET'])
def get_listings():
    query = f'''
        SELECT *
        FROM students
    '''
    
    cursor = db.get_db().cursor()

    cursor.execute(query)

    theData = cursor.fetchall() 

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response