########################################################
# Developer blueprint of endpoints
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
developer = Blueprint('developer', __name__)

# Route 1: Monitor inconsistencies in data
@developer.route('/data_logs', methods=['GET'])
def get_data_logs():
    query = f'''
        SELECT *
        FROM dataLogs
        WHERE details IS NULL OR timestamp IS NULL
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# Route 2: View user feedback
@developer.route('/user_feedback', methods =[GET])
def get_user_feedback():
    query = f'''
        SELECT *
        FROM userFeedback
        WHERE status = 'Active'
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

