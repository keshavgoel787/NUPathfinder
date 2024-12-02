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
jobs = Blueprint('jobs', __name__)

#------------------------------------------------------------
# Get all the students from the database, package them up,
# and return them to the client
# ------------------------------------------------------------
# Get all the job listings from the database
@jobs.route('/jobs/<jobID>', methods=['GET'])
def get_job(jobID):
    query = '''
        SELECT j.position, j.startDate, j.endDate, j.description, c.name
        FROM jobs j
        JOIN Recruiters r ON j.recID = r.recID
        JOIN Companies c ON r.companyID = c.companyID
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response