########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
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
students = Blueprint('students', __name__)

#------------------------------------------------------------
# Get all the students from the database, package them up,
# and return them to the client
@students.route('/students', methods=['GET'])
def get_listings():
    query = '''
        SELECT  id, 
                position, 
                start_date, 
                end_date, 
                description
        FROM jobs
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of students
    cursor.execute(query)

    # fetch all the data from the cursor
    # The cursor will return the data as a 
    # Python Dictionary
    theData = cursor.fetchall()

    # Create a HTTP Response object and add results of the query to it
    # after "jasonify"-ing it.
    response = make_response(jsonify(theData))
    # set the proper HTTP Status code of 200 (meaning all good)
    response.status_code = 200
    # send the response back to the client
    return response

# ------------------------------------------------------------
# get product information about a specific product
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send 
# parameterized information into the route handler.
@students.route('/listing/<id>', methods=['GET'])
def get_listing_detail (id):

    query = f'''SELECT id, 
                       position, 
                       start_date, 
                       end_date, 
                       description 
                FROM students 
                WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.  
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes. 
    current_app.logger.info(f'GET /listing/<id> query={query}')

    # get the database connection, execute the query, and 
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect. 
    current_app.logger.info(f'GET /listing/<id> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response
    
# ------------------------------------------------------------
# This is a POST route to add a new product.
# Remember, we are using POST routes to create new entries
# in the database. 
@students.route('/addSkill', methods=['POST'])
def add_new_skill():
    
    # In a POST request, there is a 
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    name = the_data['skill_name']
    description = the_data['skill_description']
    category = the_data['skill_category']
    student_ID = the_data['student_id']
    proficiency = the_data['skill_proficiency']
    
    query = f'''
        INSERT INTO skills (skill_name,
                              description,
                              category, 
                              student_ID,
                              proficiency)
        VALUES ('{name}', '{description}', '{category}', '{student_ID}', '{proficiency})
    '''
    # TODO: Make sure the version of the query above works properly
    # Constructing the query
    # query = 'insert into students (product_name, description, category, list_price) values ("'
    # query += name + '", "'
    # query += description + '", "'
    # query += category + '", '
    # query += str(price) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    response = make_response("Successfully added skill")
    response.status_code = 200
    return response

# ------------------------------------------------------------
# This is a stubbed route to update a product in the catalog
# The SQL query would be an UPDATE. 
@students.route('/skill/<proficieny>', methods = ['PUT'])
def update_skill(name):
    skill_info = request.json
    current_app.logger.info(skill_info)

    # Extracting variables to update
    proficiency = skill_info.get('proficiency', None)
    description = skill_info.get('description', None)

    # Constructing the update query with parameterized inputs to prevent SQL injection
    query = '''
        UPDATE skills
        SET proficiency = %s
        WHERE id = %s
    '''

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query, (proficiency, id))
    db.get_db().commit()

    response = make_response("Successfully updated skill")
    response.status_code = 200
    return response