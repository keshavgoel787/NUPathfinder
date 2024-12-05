from flask import Blueprint, request, jsonify, make_response, current_app
from backend.db_connection import db

# Blueprint for department head routes
departmenthead = Blueprint('departmenthead', __name__)

# Route to get skill gaps
@departmenthead.route('/Gaps', methods=['GET'])
def get_skill_gaps():
    try:
        query = "SELECT * FROM SkillGaps"
        cursor = db.get_db().cursor()
        cursor.execute(query)
        data = cursor.fetchall()
        return jsonify(data)
    except Exception as e:
        current_app.logger.error(f"Error fetching skill gaps: {e}")
        return make_response("Internal Server Error", 500)


# Route to get total student skill count
@departmenthead.route('/totalstudent', methods=['GET'])
def get_total_student():
    try:
        query = '''
            SELECT COUNT(name) as total, name
            FROM studentSkills
            GROUP BY name
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query)
        data = cursor.fetchall()
        return jsonify(data)
    except Exception as e:
        current_app.logger.error(f"Error fetching total student skills: {e}")
        return make_response("Internal Server Error", 500)


# Route to get total job skill count
@departmenthead.route('/totaljob', methods=['GET'])
def get_total_job():
    try:
        query = '''
            SELECT COUNT(name) as total, name
            FROM jobsSkills
            GROUP BY name
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query)
        data = cursor.fetchall()
        return jsonify(data)
    except Exception as e:
        current_app.logger.error(f"Error fetching total job skills: {e}")
        return make_response("Internal Server Error", 500)


# Routes to manage notes
@departmenthead.route('/Note/<department_ID>', methods=['GET', 'POST'])
def manage_note(department_ID):
    if request.method == 'POST':
        try:
            the_data = request.json
            content = the_data.get('content')
            if not content:
                return make_response("Content is required", 400)

            query = '''
                INSERT INTO Notes(userID, content)
                VALUES (%s, %s)
            '''
            cursor = db.get_db().cursor()
            cursor.execute(query, (department_ID, content))
            db.get_db().commit()
            return make_response("Successfully added Note", 200)
        except Exception as e:
            current_app.logger.error(f"Error adding note: {e}")
            return make_response("Internal Server Error", 500)
    else:
        try:
            query = '''
                SELECT *
                FROM Notes
                WHERE userID = %s
            '''
            cursor = db.get_db().cursor()
            cursor.execute(query, (department_ID,))
            data = cursor.fetchall()
            return jsonify(data)
        except Exception as e:
            current_app.logger.error(f"Error fetching notes: {e}")
            return make_response("Internal Server Error", 500)


@departmenthead.route('/Note/<department_ID>/<noteID>', methods=['DELETE'])
def delete_note(department_ID, noteID):
    try:
        query = '''
            DELETE FROM Notes
            WHERE userID = %s AND noteID = %s
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (department_ID, noteID))
        db.get_db().commit()
        return make_response("Successfully Deleted Note", 200)
    except Exception as e:
        current_app.logger.error(f"Error deleting note: {e}")
        return make_response("Internal Server Error", 500)


# Route to recommend courses
@departmenthead.route('/course/recommend', methods=['GET'])
def recommend_courses():
    try:
        query = '''
            SELECT Courses.name, SkillGaps.skill_name
            FROM SkillGaps
            JOIN CourseSkills ON SkillGaps.skill_name = CourseSkills.name 
            JOIN Courses ON CourseSkills.courseID = Courses.courseID
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query)
        data = cursor.fetchall()
        return jsonify(data)
    except Exception as e:
        current_app.logger.error(f"Error recommending courses: {e}")
        return make_response("Internal Server Error", 500)


# Route to get courses for a department
@departmenthead.route('/course/<department_ID>', methods=['GET'])
def get_course(department_ID):
    try:
        query = '''
            SELECT DISTINCT * 
            FROM Courses
            WHERE Courses.departmentID = %s
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (department_ID,))
        data = cursor.fetchall()
        return jsonify(data)
    except Exception as e:
        current_app.logger.error(f"Error fetching courses: {e}")
        return make_response("Internal Server Error", 500)

@departmenthead.route('/courseskills/<courseID>', methods=['GET'])
def get_course_skills(courseID):
    try:
        query = '''
            SELECT * 
            FROM CourseSkills
            WHERE courseID = %s
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (courseID))
        data = cursor.fetchall()
        return jsonify(data)
    except Exception as e:
        current_app.logger.error(f"Error fetching courses: {e}")
        return make_response("Internal Server Error", 500)


# Route to add a new course
@departmenthead.route('/addcourse/<department_ID>', methods=['POST'])
def add_course(department_ID):
    try:
        the_data = request.json
        name = the_data.get('name')
        description = the_data.get('description')
        if not name or not description:
            return make_response("Name and description are required", 400)

        query = '''
            INSERT INTO Courses(departmentID, name, description)
            VALUES (%s, %s, %s)
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (department_ID, name, description))
        db.get_db().commit()
        return make_response("Successfully added Course", 200)
    except Exception as e:
        current_app.logger.error(f"Error adding course: {e}")
        return make_response("Internal Server Error", 500)


# Route to delete a course
@departmenthead.route('/deletecourse/<department_ID>/<courseID>', methods=['DELETE'])
def delete_course(department_ID, courseID):
    try:
        query = '''
            DELETE FROM Courses
            WHERE departmentID = %s AND courseID = %s
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (department_ID, courseID))
        db.get_db().commit()
        return make_response("Successfully Deleted Course", 200)
    except Exception as e:
        current_app.logger.error(f"Error deleting course: {e}")
        return make_response("Internal Server Error", 500)

@departmenthead.route('/updatecourseinfo/<department_ID>/<courseID>', methods = ['PUT'])
def update_course_info(department_ID, courseID):
    skill_info = request.json

    course_name = skill_info.get('cname')
    course_description = skill_info.get('cdescription')

    current_app.logger.info(skill_info)

    query = '''
        UPDATE Courses SET
            name = %s,
            description = %s
        WHERE departmentID=%s AND courseID=%s
    ''' 

    conn = db.get_db() 
    cursor = conn.cursor() 

    cursor.execute(query, (course_name, course_description, department_ID, courseID))

    conn.commit()

    response = make_response(jsonify({"message": "Job updated successfully"}))
    response.status_code = 200
    return response

@departmenthead.route('/addcourseskill/<courseID>', methods = ['POST'])
def add_course_skil(courseID):
    the_data = request.json
    current_app.logger.info(the_data)

    name = the_data['skill_name']

    query = '''
        INSERT INTO CourseSkills(courseID, name)
        VALUES (%s, %s)
    '''
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query, (courseID, name))
    db.get_db().commit()

    response = make_response("Successfully added skill")
    response.status_code = 200
    return response
