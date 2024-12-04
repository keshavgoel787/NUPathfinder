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
@developer.route('/user_feedback', methods =['GET'])
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

# Route 3: Automated test results
@developer.route('/test_results', methods=['POST'])
def log_test_results():
    the_data = request.json
    current_app.logger.info(the_data)

    feature_id = the_data['featureID']
    test_type = the_data['testType']
    result = the_data['result']
    run_date = the_data['runDate']

    query = f'''
        INSERT INTO testing (featureID, testType, result, runDate)
        VALUES (%s, %s, %s, %s)
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query, (feature_id, test_type, result, run_date))
    db.get_db().commit()

    response = make_response("Successfully logged test results")
    response.status_code = 200
    return response

# Route 4: Update Documentation
@developer.route('/documentation/<doc_id>', methods=['PUT'])
def update_documentation(doc_id):
    the_data = request.json
    current_app.logger.info(the_data)

    section = the_data['section']
    details = the_data['details']
    last_updated = the_data['lastUpdated']

    query = f'''
        UPDATE documentation
        SET section = %s, details = %s, lastUpdated = %s
        WHERE docID = %s
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query, (section, details, last_updated, doc_id))
    db.get_db().commit()

    response = make_response("Successfully updated documentation")
    response.status_code = 200
    return response






