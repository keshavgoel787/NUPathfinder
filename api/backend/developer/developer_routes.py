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

# Monitor inconsistencies in data
@developer.route('/data_logs', methods=['GET'])
def get_data_logs():
    try:
        query = '''
            SELECT *
            FROM DataLogs
            WHERE details IS NULL OR timestamp IS NULL
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query)
        theData = cursor.fetchall()
        current_app.logger.info(f"Fetched {len(theData)} inconsistent data logs")
        response = make_response(jsonify(theData))
        response.status_code = 200
        return response
    except Exception as e:
        current_app.logger.error(f"Error fetching data logs: {str(e)}")
        response = make_response(jsonify({"error": "Failed to fetch data logs"}))
        response.status_code = 500
        return response


# Fix data log inconsistencies
@developer.route('/data_logs/<log_id>', methods=['PUT'])
def update_data_log(log_id):
    try:
        the_data = request.json
        details = the_data.get('details')
        timestamp = the_data.get('timestamp')

        query = f'''
            UPDATE DataLogs
            SET details = %s, timestamp = %s
            WHERE logID = %s
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (details, timestamp, log_id))
        db.get_db().commit()
        current_app.logger.info(f"Updated data log {log_id}")
        response = make_response("Successfully updated data log")
        response.status_code = 200
        return response
    except Exception as e:
        current_app.logger.error(f"Error updating data log: {str(e)}")
        response = make_response(jsonify({"Error": "Failure to update data log"}))
        response.status_code = 500
        return response

    

# View user feedback
@developer.route('/user_feedback', methods=['GET'])
def get_user_feedback():
    try:
        query = '''
            SELECT *
            FROM UserFeedback
            WHERE rating >= 3
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query)
        theData = cursor.fetchall()
        current_app.logger.info(f"Fetched {len(theData)} user feedback entries")
        response = make_response(jsonify(theData))
        response.status_code = 200
        return response
    except Exception as e:
        current_app.logger.error(f"Error fetching user feedback: {str(e)}")
        response = make_response(jsonify({"error": "Failed to fetch user feedback"}))
        response.status_code = 500
        return response


# Automated test results
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

# retrieve Documentation
@developer.route('/documentation/<doc_id>', methods=['GET'])
def get_documentation(doc_id):
    try:
        query = '''
            SELECT *
            FROM Documentation
            WHERE docID = %s
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (doc_id,))
        theData = cursor.fetchone()
        if theData:
            current_app.logger.info(f"Fetched documentation for docID {doc_id}")
            response = make_response(jsonify(theData))
            response.status_code = 200
            return response
        else:
            response = make_response(jsonify({"error": "Documentation not found"}))
            response.status_code = 404
            return response
    except Exception as e:
        current_app.logger.error(f"Error fetching documentation: {str(e)}")
        response = make_response(jsonify({"error": "Failed to get documentation"}))
        response.status_code = 500
        return response


# Update Documentation
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

@developer.route('/interaction_data', methods=['DELETE'])
def archive_interaction_data():
    try:
        interval = request.args.get('interval', 'INTERVAL 1 YEAR')
        query = f'''
            DELETE FROM DataLogs
            WHERE timestamp < NOW() - {interval}
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

        response = make_response("Successfully archived outdated interaction data")
        response.status_code = 200
        return response
    except Exception as e:
        current_app.logger.error(f"Error archiving interaction data: {str(e)}")
        response = make_response(jsonify({"error": "Failed to archive interaction data"}))
        response.status_code = 500
        return response






