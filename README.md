# NU Pathfinder

An advanced way for Northeastern Students, Recruiters, Department Heads, and Developers to analyze skills. Utilizes Flask Routes to access the SQL database and Streamlit to show insights for that data. 

## Tech Stack
1. Frontend: Python Streamlit
2. Middleware: MySQL
3. Backend: Python Flask

## How to Run

1. In terminal run the command: docker compose up
2. Then click on the link to access the streamlit

.env file format:
stored in /api 

SECRET_KEY=someCrazyS3cR3T!Key.!
DB_USER=root  
DB_HOST=db  
DB_PORT=3306  
DB_NAME=NUPathfinder  
MYSQL_ROOT_PASSWORD=password  

## Personas
1. Persona 1: The Student Persona
   a. A student who hopes to apply to co-ops and gain the skills to succeed
2. Persona 2: The Recruiter Persona
   b. A company recruiter who hopes to gain the most talented students who align with company skills and need
3. Persona 3: The Department Head Persona
   c. A Department Head who analyzes data related to company and student skills. Through this data they can find insights and lead students to be succesful
4. Persona 4: The Developer Persona
   d. A Developer who works for NU Pathfinder to run tests, review feeback, and fix features to allows users the best experience


