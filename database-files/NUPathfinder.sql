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
    Username INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    proficiency VARCHAR(50) NOT NULL,
    PRIMARY KEY (Username, name),
    FOREIGN KEY (Username) REFERENCES students(studentID),
    FOREIGN KEY (name) REFERENCES skills(name)
);

-- Job Skills Table
DROP TABLE IF EXISTS jobsSkills;
CREATE TABLE IF NOT EXISTS jobsSkills (
    jobID INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (jobID, name),
    FOREIGN KEY (jobID) REFERENCES jobs(jobID),
    FOREIGN KEY (name) REFERENCES skills(name)
);

-- Applications Table
DROP TABLE IF EXISTS application;
CREATE TABLE IF NOT EXISTS application (
    applicationID INT AUTO_INCREMENT NOT NULL,
    studentID INT NOT NULL,
    jobID INT NOT NULL,
    dateOfApplication DATE DEFAULT '2024-11-20',
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
    FOREIGN KEY (name) REFERENCES skills(name)
);

-- Notes Table
DROP TABLE IF EXISTS Notes;
CREATE TABLE IF NOT EXISTS Notes (
    noteID INT AUTO_INCREMENT NOT NULL,
    userID INT NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY (noteID,userID),
    FOREIGN KEY (userID) REFERENCES DepartmentHead(userID)
);

-- SkillsGap Table
DROP TABLE IF EXISTS SkillsGap;
CREATE TABLE IF NOT EXISTS SkillsGap (
    name VARCHAR(100) NOT NULL,
    analysisID INT NOT NULL,
    status VARCHAR(50),
    PRIMARY KEY (name, analysisID),
    FOREIGN KEY (name) REFERENCES skills(name)
);

-- SkillsGapAnalysis Table
DROP TABLE IF EXISTS SkillsGapAnalysis;
CREATE TABLE IF NOT EXISTS SkillsGapAnalysis (
    name VARCHAR(100) NOT NULL, -- Include name to form the composite key
    analysisID INT NOT NULL,
    userID INT NOT NULL,
    gapMagnitude INT,
    dateObserved DATE,
    PRIMARY KEY (userID, analysisID), -- Composite primary key
    FOREIGN KEY (name, analysisID) REFERENCES SkillsGap(name, analysisID),
    FOREIGN KEY (userID) REFERENCES DepartmentHead(userID)
);

-- SkillsTrend Table
DROP TABLE IF EXISTS SkillsTrend;
CREATE TABLE IF NOT EXISTS SkillsTrend (
    trendID INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    PRIMARY KEY (trendID),
    FOREIGN KEY (name) REFERENCES skills(name)
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

USE NUPathfinder;

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
('Emily', 'Johnson', 1),
('Robert', 'Brown', 2),
('Sophia', 'Davis', 3);

-- Insert Sample Data into Jobs
INSERT INTO jobs (position, description, startDate, endDate, recID)
VALUES
('Software Engineer Intern', 'Develop web applications using modern frameworks.', '2024-06-01', '2024-08-31', 1),
('Data Analyst Intern', 'Analyze datasets to provide actionable insights.', '2024-05-15', '2024-08-15', 2),
('Mechanical Engineer Intern', 'Assist in prototyping and testing.', '2024-05-01', '2024-07-31', 3);

-- Insert Sample Data into Skills
INSERT INTO skills (name, description, category)
VALUES
('Python', 'Programming language', 'Programming'),
('Data Analysis', 'Analyzing datasets', 'Data Science'),
('Prototyping', 'Creating and testing prototypes', 'Mechanical');

-- Insert Sample Data into Student Skills
INSERT INTO studentSkills (Username, name, proficiency)
VALUES
(1, 'Python', 'Advanced'),
(2, 'Data Analysis', 'Intermediate'),
(3, 'Prototyping', 'Basic');

-- Insert Sample Data into Job Skills
INSERT INTO jobsSkills (jobID, name)
VALUES
(1, 'Python'),
(2, 'Data Analysis'),
(3, 'Prototyping');

-- Insert Sample Data into Applications
INSERT INTO application (studentID, jobID, matchPercent, status)
VALUES
(1, 1, 85, 'Submitted'),
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
(2, 'Thermodynamics', 'Study of heat and energy transfer.');

-- Insert Sample Data into Course Skills
INSERT INTO CourseSkills (courseID, name)
VALUES
(1, 'Python'),
(2, 'Prototyping');

-- Insert Sample Data into Notes
INSERT INTO Notes (userID, content)
VALUES
(1, 'Review curriculum for upcoming semester.'),
(2, 'Discuss research opportunities with faculty.');

-- Insert Sample Data into SkillsGap
INSERT INTO SkillsGap (name, analysisID, status)
VALUES
('Python', 1, 'In Progress'),
('Data Analysis', 2, 'Completed');

-- Insert Sample Data into SkillsGapAnalysis
INSERT INTO SkillsGapAnalysis (name, analysisID, userID, gapMagnitude, dateObserved)
VALUES
('Python', 1, 1, 3, '2024-11-01'),
('Data Analysis', 2, 2, 1, '2024-11-10');

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

