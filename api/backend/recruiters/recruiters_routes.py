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

#------------------------------------------------------------
# Get all the products from the database, package them up,
# and return them to the client

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
