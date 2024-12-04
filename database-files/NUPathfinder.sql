-- Database Creation
DROP DATABASE IF EXISTS NUPathfinder;
CREATE DATABASE IF NOT EXISTS NUPathfinder;

USE NUPathfinder;

-- Students Table
DROP TABLE IF EXISTS students;
CREATE TABLE IF NOT EXISTS students (
    studentID INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    major VARCHAR(50) NOT NULL,
    PRIMARY KEY (studentID)
);

-- Companies Table
DROP TABLE IF EXISTS Companies;
CREATE TABLE IF NOT EXISTS Companies (
    companyID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(75) NOT NULL,
    employeeNum INT,
    PRIMARY KEY (companyID)
);

-- Recruiters Table
DROP TABLE IF EXISTS Recruiters;
CREATE TABLE IF NOT EXISTS Recruiters (
    recID INT AUTO_INCREMENT NOT NULL,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    companyID INT NOT NULL,
    PRIMARY KEY (recID),
    FOREIGN KEY (companyID) REFERENCES Companies(companyID)
);
-- Developers Table
DROP TABLE IF EXISTS Developer;
CREATE TABLE IF NOT EXISTS Developer (
    developerID INT AUTO_INCREMENT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    role VARCHAR(100) NOT NULL,
    experienceLevel VARCHAR(50),
    PRIMARY KEY (developerID)
);
-- Website Table
DROP TABLE IF EXISTS Website;
CREATE TABLE IF NOT EXISTS Website (
    appID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    version VARCHAR(50),
    status VARCHAR(50),
    PRIMARY KEY (appID)
);

-- Feature Table
DROP TABLE IF EXISTS Feature;
CREATE TABLE IF NOT EXISTS Feature (
    featureID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(50),
    PRIMARY KEY (featureID)
);

-- DataLogs Table
DROP TABLE IF EXISTS DataLogs;
CREATE TABLE IF NOT EXISTS DataLogs (
    logID INT AUTO_INCREMENT NOT NULL,
    type VARCHAR(100),
    details TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    developerID INT NOT NULL,
    appID INT NOT NULL,
    PRIMARY KEY (logID),
    FOREIGN KEY (developerID) REFERENCES Developer(developerID),
    FOREIGN KEY (appID) REFERENCES Website(appID)
);

-- Testing Table
DROP TABLE IF EXISTS Testing;
CREATE TABLE IF NOT EXISTS Testing (
    testID INT AUTO_INCREMENT NOT NULL,
    featureID INT NOT NULL,
    testType VARCHAR(100),
    result VARCHAR(50),
    runDate DATE,
    PRIMARY KEY (testID),
    FOREIGN KEY (featureID) REFERENCES Feature(featureID)
);

-- Documentation Table
DROP TABLE IF EXISTS Documentation;
CREATE TABLE IF NOT EXISTS Documentation (
    docID INT AUTO_INCREMENT NOT NULL,
    section VARCHAR(100) NOT NULL,
    details TEXT NOT NULL,
    lastUpdated DATE,
    developerID INT NOT NULL,
    PRIMARY KEY (docID),
    FOREIGN KEY (developerID) REFERENCES Developer(developerID)
);


-- Jobs Table
DROP TABLE IF EXISTS jobs;
CREATE TABLE IF NOT EXISTS jobs (
    jobID INT AUTO_INCREMENT NOT NULL,
    position VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    recID INT NOT NULL,
    PRIMARY KEY (jobID),
    FOREIGN KEY (recID) REFERENCES Recruiters(recID)
);

-- Skills Table
DROP TABLE IF EXISTS skills;
CREATE TABLE IF NOT EXISTS skills (
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50),
    PRIMARY KEY (name)
);

-- Student Skills Table
DROP TABLE IF EXISTS studentSkills;
CREATE TABLE IF NOT EXISTS studentSkills (
    studentID INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    proficiency int NOT NULL,
    PRIMARY KEY (studentID, name),
    FOREIGN KEY (studentID) REFERENCES students(studentID),
    FOREIGN KEY (name) REFERENCES skills(name) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Job Skills Table
DROP TABLE IF EXISTS jobsSkills;
CREATE TABLE IF NOT EXISTS jobsSkills (
    jobID INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    proficiency INT NOT NULL,
    PRIMARY KEY (jobID, name),
    FOREIGN KEY (jobID) REFERENCES jobs(jobID),
    FOREIGN KEY (name) REFERENCES skills(name) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Applications Table
DROP TABLE IF EXISTS application;
CREATE TABLE IF NOT EXISTS application (
    applicationID INT AUTO_INCREMENT NOT NULL,
    studentID INT NOT NULL,
    jobID INT NOT NULL,
    dateOfApplication DATE DEFAULT CURRRENT_DATE,
    matchPercent INT,
    status VARCHAR(50) DEFAULT 'Submitted',
    PRIMARY KEY (applicationID),
    FOREIGN KEY (studentID) REFERENCES students(studentID),
    FOREIGN KEY (jobID) REFERENCES jobs(jobID)
);

-- Experiences Table
DROP TABLE IF EXISTS experiences;
CREATE TABLE IF NOT EXISTS experiences (
    title VARCHAR(50) NOT NULL,
    Username INT NOT NULL,
    review TEXT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    jobID INT NOT NULL,
    PRIMARY KEY (jobID, Username),
    FOREIGN KEY (Username) REFERENCES students(studentID),
    FOREIGN KEY (jobID) REFERENCES jobs(jobID)
);

-- BlackListed Table
DROP TABLE IF EXISTS BlackListed;
CREATE TABLE IF NOT EXISTS BlackListed (
    recID INT NOT NULL,
    studentID INT NOT NULL,
    PRIMARY KEY (recID, studentID),
    FOREIGN KEY (recID) REFERENCES Recruiters(recID),
    FOREIGN KEY (studentID) REFERENCES students(studentID)
);

-- Department Head Table
DROP TABLE IF EXISTS DepartmentHead;
CREATE TABLE IF NOT EXISTS DepartmentHead (
    userID INT AUTO_INCREMENT NOT NULL,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    PRIMARY KEY (userID)
);

-- Department Table
DROP TABLE IF EXISTS Department;
CREATE TABLE IF NOT EXISTS Department (
    departmentID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    DH_ID INT,
    PRIMARY KEY (departmentID),
    FOREIGN KEY (DH_ID) REFERENCES DepartmentHead(userID)
);

-- Courses Table
DROP TABLE IF EXISTS Courses;
CREATE TABLE IF NOT EXISTS Courses (
    courseID INT AUTO_INCREMENT NOT NULL,
    departmentID INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    PRIMARY KEY (courseID),
    FOREIGN KEY (departmentID) REFERENCES Department(departmentID)
);

-- Course Skills Table
DROP TABLE IF EXISTS CourseSkills;
CREATE TABLE IF NOT EXISTS CourseSkills (
    courseID INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (courseID, name),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID),
    FOREIGN KEY (name) REFERENCES skills(name) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Notes Table
DROP TABLE IF EXISTS Notes;
CREATE TABLE IF NOT EXISTS Notes (
    noteID INT AUTO_INCREMENT NOT NULL,
    userID INT NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY (noteID,userID),
    UNIQUE(noteID),
    FOREIGN KEY (userID) REFERENCES DepartmentHead(userID)
);

DROP TABLE IF EXISTS UserFeedback;
CREATE TABLE IF NOT EXISTS UserFeedback (
    feedbackID INT AUTO_INCREMENT NOT NULL,
    userID INT NOT NULL,
    featureID INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    noteID INT NOT NULL,
    PRIMARY KEY (feedbackID),
    FOREIGN KEY (featureID) REFERENCES Feature(featureID),
    FOREIGN KEY (userID) REFERENCES Developer(developerID),
    FOREIGN KEY (noteID) REFERENCES Notes(noteID)
);

-- SkillsTrend Table
DROP TABLE IF EXISTS SkillsTrend;
CREATE TABLE IF NOT EXISTS SkillsTrend (
    trendID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    PRIMARY KEY (trendID),
    FOREIGN KEY (name) REFERENCES skills(name) ON UPDATE CASCADE ON DELETE CASCADE
);

-- IndustryTrend Table
DROP TABLE IF EXISTS IndustryTrend;
CREATE TABLE IF NOT EXISTS IndustryTrend (
    trendID INT NOT NULL,
    userID INT NOT NULL,
    trendType VARCHAR(100),
    dateObserved DATE,
    PRIMARY KEY (trendID),
    FOREIGN KEY (trendID) REFERENCES SkillsTrend(trendID),
    FOREIGN KEY (userID) REFERENCES DepartmentHead(userID)
);

CREATE OR REPLACE VIEW SkillGaps AS
SELECT js.name AS skill_name
FROM jobsSkills js
LEFT JOIN studentSkills ss ON js.name = ss.name
WHERE ss.name IS NULL;


-- Insert Sample Data into Students
INSERT INTO students (username, firstName, lastName, major)
VALUES
('jdoe', 'John', 'Doe', 'Computer Science'),
('asmith', 'Alice', 'Smith', 'Data Science'),
('bwong', 'Brian', 'Wong', 'Mechanical Engineering');

-- Insert Sample Data into Companies
INSERT INTO Companies (name, employeeNum)
VALUES
('TechCorp', 5000),
('DataSolutions', 1200),
('MechWorks', 300);

-- Insert Sample Data into Recruiters
INSERT INTO Recruiters (firstName, lastName, companyID)
VALUES
('Jane', 'Dough', 1),
('Robert', 'Brown', 2),
('Sophia', 'Davis', 3);

-- Insert Sample Data into Jobs
INSERT INTO jobs (position, description, startDate, endDate, recID)
VALUES
('Software Engineer Intern', 'Develop web applications using modern frameworks.', '2024-06-01', '2024-08-31', 1),
('ML Supervisor', 'Help interns with machine learning.', '2024-08-01', '2024-10-31', 1),
('Data Analyst Intern', 'Analyze datasets to provide actionable insights.', '2024-05-15', '2024-08-15', 2),
('Mechanical Engineer Intern', 'Assist in prototyping and testing.', '2024-05-01', '2024-07-31', 3);

-- Insert Sample Data into Skills
INSERT INTO skills (name, description, category)
VALUES
('Python', 'Programming language', 'Programming'),
('Data Analysis', 'Analyzing datasets', 'Data Science'),
('Prototyping', 'Creating and testing prototypes', 'Mechanical'),
('Java', 'Programming Language', 'Programming');

-- Insert Sample Data into Student Skills
INSERT INTO studentSkills (studentID, name, proficiency)
VALUES
(1, 'Python', 4),
(2, 'Data Analysis', 3),
(3, 'Prototyping', 1);

-- Insert Sample Data into Job Skills
INSERT INTO jobsSkills (jobID, name, proficiency)
VALUES
(1, 'Python', 1),
(2, 'Data Analysis', 4),
(3, 'Prototyping', 3),
(4, 'Java', 2);
-- Insert Sample Data into Applications
INSERT INTO application (studentID, jobID, matchPercent, status)
VALUES
(1, 1, 85, 'Submitted'),
(2, 1, 34, 'Interviewing'),
(3, 1, 91, 'Submitted'),
(2, 2, 90, 'Interviewing'),
(3, 3, 75, 'Submitted');

-- Insert Sample Data into Experiences
INSERT INTO experiences (title, Username, review, rating, jobID)
VALUES
('Web Development Project', 1, 'Worked on building scalable web apps.', 5, 1),
('Data Analysis Project', 2, 'Analyzed customer behavior for better targeting.', 4, 2),
('Mechanical Prototyping', 3, 'Designed and tested machine parts.', 4, 3);

-- Insert Sample Data into BlackListed
INSERT INTO BlackListed (recID, studentID)
VALUES
(1, 3);

-- Insert Sample Data into Department Head
INSERT INTO DepartmentHead (firstName, lastName)
VALUES
('Michael', 'Lee'),
('Jessica', 'Taylor');

-- Insert Sample Data into Department
INSERT INTO Department (name, DH_ID)
VALUES
('Computer Science', 1),
('Mechanical Engineering', 2);

-- Insert Sample Data into Courses
INSERT INTO Courses (departmentID, name, description)
VALUES
(1, 'Intro to Programming', 'Learn basic programming concepts.'),
(2, 'Thermodynamics', 'Study of heat and energy transfer.'),
(1, 'Fundies 2', 'Learn Java');

-- Insert Sample Data into Course Skills
INSERT INTO CourseSkills (courseID, name)
VALUES
(1, 'Python'),
(2, 'Prototyping'),
(3, 'Java');

-- Insert Sample Data into Notes
INSERT INTO Notes (userID, content)
VALUES
(1, 'Review curriculum for upcoming semester.'),
(2, 'Discuss research opportunities with faculty.');


-- Insert Sample Data into SkillsTrend
INSERT INTO SkillsTrend (name, description)
VALUES
('Python', 'Increasing demand for Python skills.'),
('Data Analysis', 'Data analysis skills are becoming essential.');

-- Insert Sample Data into IndustryTrend
INSERT INTO IndustryTrend (trendID, userID, trendType, dateObserved)
VALUES
(1, 1, 'Emerging', '2024-11-05'),
(2, 2, 'Established', '2024-11-10');

-- Insert Sample Data into Developer
INSERT INTO Developer (username, firstName, lastName, role, experienceLevel)
VALUES
('sgates', 'Steve', 'Gates', 'Full-Stack Developer', 'Senior');

INSERT INTO Website (name, version, status)
VALUES
('NU Pathfinder', '1.0', 'Active');

-- Insert Sample Data into Documentation
INSERT INTO Documentation (section, details, lastUpdated, developerID)
VALUES
('User Management', 'Handles user roles and permissions.', '2024-11-20', 1),
('API Integration', 'Documents API endpoints for external systems.', '2024-11-20', 1);

-- Insert Sample Data into Feature
INSERT INTO Feature (name, description, status)
VALUES
('Advanced Search', 'Enhanced search for users.', 'Active'),
('Real-Time Notifications', 'Sends real-time updates to users.', 'Testing');

-- Insert Sample Data into UserFeedback
INSERT INTO UserFeedback (userID, featureID, rating, comments, timestamp, noteID)
VALUES
(1, 1, 5, 'Great functionality!', '2024-11-20',1),
(1, 2, 4, 'Useful feature for alerts.', '2024-11-20',2);

-- Insert Sample Data into DataLogs
INSERT INTO DataLogs (type, details, timestamp, developerID, appID)
VALUES
('Error', 'Resolved database connection issue.', '2024-11-18', 1, 1),
('Performance', 'Optimized page load times.', '2024-11-19', 1, 1);

-- Insert Sample Data into Testing
INSERT INTO Testing (featureID, testType, result, runDate)
VALUES
(1, 'Regression Testing', 'Passed', '2024-11-19'),
(2, 'Integration Testing', 'Passed', '2024-11-20');