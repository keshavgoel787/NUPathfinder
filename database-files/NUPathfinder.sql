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
    dateOfApplication DATE DEFAULT '2024-11-20',
    matchPercent INT,
    status VARCHAR(50) DEFAULT 'Submitted',
    PRIMARY KEY (applicationID),
    FOREIGN KEY (studentID) REFERENCES students(studentID),
    FOREIGN KEY (jobID) REFERENCES jobs(jobID) ON UPDATE CASCADE ON DELETE CASCADE
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
    FOREIGN KEY (departmentID) REFERENCES Department(departmentID) ON UPDATE CASCADE ON DELETE CASCADE
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

-- Drop the existing SkillGaps view if it exists
DROP VIEW IF EXISTS SkillGaps;
-- Create the updated SkillGaps view
CREATE OR REPLACE VIEW SkillGaps AS
SELECT
    js.name AS skill_name
FROM
    jobsSkills js
LEFT JOIN
    studentSkills ss
ON
    js.name = ss.name
GROUP BY
    js.name, js.proficiency
HAVING
    AVG(ss.proficiency) IS NULL -- Include skills not present in studentSkills
    OR ABS(js.proficiency - AVG(ss.proficiency)) > 0.5; -- Include skills with proficiency mismatch



-- Insert Sample Data into Students
insert into students (studentID, firstName, lastName, username, major) values (1, 'Tarah', 'L''Archer', 'tlarcher0', 'Computer Science');
insert into students (studentID, firstName, lastName, username, major) values (2, 'Stacee', 'Fortun', 'sfortun1', 'Software Engineering');
insert into students (studentID, firstName, lastName, username, major) values (3, 'Patrizia', 'Tandy', 'ptandy2', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (4, 'Lucio', 'Venneur', 'lvenneur3', 'Data Science');
insert into students (studentID, firstName, lastName, username, major) values (5, 'Justinn', 'Chellam', 'jchellam4', 'Computer Engineering');
insert into students (studentID, firstName, lastName, username, major) values (6, 'Diego', 'Harborow', 'dharborow5', 'Information Technology');
insert into students (studentID, firstName, lastName, username, major) values (7, 'Gwennie', 'Gianulli', 'ggianulli6', 'Data Science');
insert into students (studentID, firstName, lastName, username, major) values (8, 'Cassy', 'Book', 'cbook7', 'Network Administration');
insert into students (studentID, firstName, lastName, username, major) values (9, 'Pasquale', 'Andrault', 'pandrault8', 'Cybersecurity');
insert into students (studentID, firstName, lastName, username, major) values (10, 'Olivero', 'McCluney', 'omccluney9', 'Network Administration');
insert into students (studentID, firstName, lastName, username, major) values (11, 'Myca', 'Lobb', 'mlobba', 'Software Engineering');
insert into students (studentID, firstName, lastName, username, major) values (12, 'Fredericka', 'Oran', 'foranb', 'Data Science');
insert into students (studentID, firstName, lastName, username, major) values (13, 'Weber', 'Heinel', 'wheinelc', 'Web Development');
insert into students (studentID, firstName, lastName, username, major) values (14, 'Kaleb', 'Van Hove', 'kvanhoved', 'Data Science');
insert into students (studentID, firstName, lastName, username, major) values (15, 'Donavon', 'D''Antoni', 'ddantonie', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (16, 'Katerine', 'Coit', 'kcoitf', 'Information Technology');
insert into students (studentID, firstName, lastName, username, major) values (17, 'Leeann', 'Probbings', 'lprobbingsg', 'Data Science');
insert into students (studentID, firstName, lastName, username, major) values (18, 'Land', 'D''Cruze', 'ldcruzeh', 'Computer Science');
insert into students (studentID, firstName, lastName, username, major) values (19, 'Regen', 'Trunby', 'rtrunbyi', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (20, 'Ettore', 'Burtenshaw', 'eburtenshawj', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (21, 'Chiquita', 'Cromett', 'ccromettk', 'Information Technology');
insert into students (studentID, firstName, lastName, username, major) values (22, 'Alvera', 'Giacobilio', 'agiacobiliol', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (23, 'Freda', 'Littrick', 'flittrickm', 'Data Science');
insert into students (studentID, firstName, lastName, username, major) values (24, 'Charla', 'Tanti', 'ctantin', 'Computer Science');
insert into students (studentID, firstName, lastName, username, major) values (25, 'Ogden', 'Jamblin', 'ojamblino', 'Data Science');
insert into students (studentID, firstName, lastName, username, major) values (26, 'Wenda', 'Ivanikhin', 'wivanikhinp', 'Computer Engineering');
insert into students (studentID, firstName, lastName, username, major) values (27, 'Taddeo', 'Thody', 'tthodyq', 'Computer Engineering');
insert into students (studentID, firstName, lastName, username, major) values (28, 'Thorvald', 'Bossel', 'tbosselr', 'Cybersecurity');
insert into students (studentID, firstName, lastName, username, major) values (29, 'Conan', 'Baughan', 'cbaughans', 'Computer Engineering');
insert into students (studentID, firstName, lastName, username, major) values (30, 'Valentin', 'Beumant', 'vbeumantt', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (31, 'Araldo', 'Serman', 'asermanu', 'Cybersecurity');
insert into students (studentID, firstName, lastName, username, major) values (32, 'Bowie', 'Dunkinson', 'bdunkinsonv', 'Artificial Intelligence');
insert into students (studentID, firstName, lastName, username, major) values (33, 'Cherise', 'Newgrosh', 'cnewgroshw', 'Artificial Intelligence');
insert into students (studentID, firstName, lastName, username, major) values (34, 'Markus', 'Eeles', 'meelesx', 'Computer Engineering');
insert into students (studentID, firstName, lastName, username, major) values (35, 'Loise', 'Rock', 'lrocky', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (36, 'Shirline', 'Proschke', 'sproschkez', 'Artificial Intelligence');
insert into students (studentID, firstName, lastName, username, major) values (37, 'Karola', 'Jeanet', 'kjeanet10', 'Network Administration');
insert into students (studentID, firstName, lastName, username, major) values (38, 'Cordy', 'Kyme', 'ckyme11', 'Cybersecurity');
insert into students (studentID, firstName, lastName, username, major) values (39, 'Kitti', 'Trusdale', 'ktrusdale12', 'Digital Forensics');
insert into students (studentID, firstName, lastName, username, major) values (40, 'Tull', 'Jovanovic', 'tjovanovic13', 'Artificial Intelligence');

-- Insert Sample Data into Companies
insert into Companies (name, employeeNum) values ('Fivechat', 746);
insert into Companies (name, employeeNum) values ('Dabfeed', 9744);
insert into Companies (name, employeeNum) values ('Skimia', 53);
insert into Companies (name, employeeNum) values ('Minyx', 1617);
insert into Companies (name, employeeNum) values ('Kanoodle', 5472);
insert into Companies (name, employeeNum) values ('Zoombeat', 8);
insert into Companies (name, employeeNum) values ('Wikibox', 77);
insert into Companies (name, employeeNum) values ('Dabfeed', 7);
insert into Companies (name, employeeNum) values ('Topicware', 6286);
insert into Companies (name, employeeNum) values ('Devcast', 768);
insert into Companies (name, employeeNum) values ('Abata', 32);
insert into Companies (name, employeeNum) values ('Izio', 6);
insert into Companies (name, employeeNum) values ('Edgepulse', 511);
insert into Companies (name, employeeNum) values ('Photobug', 4);
insert into Companies (name, employeeNum) values ('Quinu', 0);
insert into Companies (name, employeeNum) values ('Yoveo', 10181);
insert into Companies (name, employeeNum) values ('Yabox', 6);
insert into Companies (name, employeeNum) values ('Skipfire', 1894);
insert into Companies (name, employeeNum) values ('Feedbug', 4);
insert into Companies (name, employeeNum) values ('InnoZ', 2719);
insert into Companies (name, employeeNum) values ('Gabcube', 22);
insert into Companies (name, employeeNum) values ('Bluezoom', 8084);
insert into Companies (name, employeeNum) values ('Tagfeed', 48);
insert into Companies (name, employeeNum) values ('Lazz', 3225);
insert into Companies (name, employeeNum) values ('Avamm', 89249);
insert into Companies (name, employeeNum) values ('Topicware', 456);
insert into Companies (name, employeeNum) values ('Topicblab', 00);
insert into Companies (name, employeeNum) values ('Voolith', 290);
insert into Companies (name, employeeNum) values ('Skyndu', 1021);
insert into Companies (name, employeeNum) values ('Eare', 384);
insert into Companies (name, employeeNum) values ('Miboo', 8189);
insert into Companies (name, employeeNum) values ('Gabvine', 020);
insert into Companies (name, employeeNum) values ('Realcube', 4);
insert into Companies (name, employeeNum) values ('Realblab', 132);
insert into Companies (name, employeeNum) values ('Topiclounge', 375);
insert into Companies (name, employeeNum) values ('Realmix', 568);
insert into Companies (name, employeeNum) values ('Quire', 5);
insert into Companies (name, employeeNum) values ('Meevee', 73);
insert into Companies (name, employeeNum) values ('Realcube', 7127);
insert into Companies (name, employeeNum) values ('Bluezoom', 57568);

-- Insert Sample Data into Recruiters
insert into Recruiters (firstName, lastName, companyID) values ('Hannah', 'Denyer', 1);
insert into Recruiters (firstName, lastName, companyID) values ('Kimbra', 'Hardway', 2);
insert into Recruiters (firstName, lastName, companyID) values ('Vanya', 'Bennell', 3);
insert into Recruiters (firstName, lastName, companyID) values ('Celia', 'Master', 4);
insert into Recruiters (firstName, lastName, companyID) values ('Karilynn', 'Ivanikhin', 5);
insert into Recruiters (firstName, lastName, companyID) values ('Othelia', 'Dureden', 6);
insert into Recruiters (firstName, lastName, companyID) values ('Annis', 'Guterson', 7);
insert into Recruiters (firstName, lastName, companyID) values ('Dianne', 'Beernt', 8);
insert into Recruiters (firstName, lastName, companyID) values ('Clare', 'Gleadhall', 9);
insert into Recruiters (firstName, lastName, companyID) values ('Rebecca', 'Bulman', 10);
insert into Recruiters (firstName, lastName, companyID) values ('Jackqueline', 'Fittis', 11);
insert into Recruiters (firstName, lastName, companyID) values ('Chen', 'Gilby', 12);
insert into Recruiters (firstName, lastName, companyID) values ('Cloris', 'Thrush', 13);
insert into Recruiters (firstName, lastName, companyID) values ('Dede', 'Epine', 14);
insert into Recruiters (firstName, lastName, companyID) values ('Leonhard', 'Costerd', 15);
insert into Recruiters (firstName, lastName, companyID) values ('Rudolfo', 'Rochford', 16);
insert into Recruiters (firstName, lastName, companyID) values ('Sam', 'McDuffy', 17);
insert into Recruiters (firstName, lastName, companyID) values ('Josiah', 'Thorsby', 18);
insert into Recruiters (firstName, lastName, companyID) values ('Taite', 'Carette', 19);
insert into Recruiters (firstName, lastName, companyID) values ('Xylia', 'Dureden', 20);
insert into Recruiters (firstName, lastName, companyID) values ('Celie', 'Bull', 21);
insert into Recruiters (firstName, lastName, companyID) values ('Gallard', 'Rydings', 22);
insert into Recruiters (firstName, lastName, companyID) values ('Eben', 'Robken', 23);
insert into Recruiters (firstName, lastName, companyID) values ('Nana', 'Brabben', 24);
insert into Recruiters (firstName, lastName, companyID) values ('Cherye', 'Chiverton', 25);
insert into Recruiters (firstName, lastName, companyID) values ('Wyn', 'Farnan', 26);
insert into Recruiters (firstName, lastName, companyID) values ('Jourdain', 'Drinnan', 27);
insert into Recruiters (firstName, lastName, companyID) values ('Bennie', 'Tschiersch', 28);
insert into Recruiters (firstName, lastName, companyID) values ('Kristien', 'Eykelbosch', 29);
insert into Recruiters (firstName, lastName, companyID) values ('Tandi', 'Traviss', 30);
insert into Recruiters (firstName, lastName, companyID) values ('Tallou', 'Baison', 31);
insert into Recruiters (firstName, lastName, companyID) values ('Dulcine', 'Picardo', 32);
insert into Recruiters (firstName, lastName, companyID) values ('Maryjane', 'Weed', 33);
insert into Recruiters (firstName, lastName, companyID) values ('Robinetta', 'Duffus', 34);
insert into Recruiters (firstName, lastName, companyID) values ('Karine', 'Aggett', 35);
insert into Recruiters (firstName, lastName, companyID) values ('Trudey', 'Burgher', 36);
insert into Recruiters (firstName, lastName, companyID) values ('Leonore', 'Cradock', 37);
insert into Recruiters (firstName, lastName, companyID) values ('Nobe', 'Izsak', 38);
insert into Recruiters (firstName, lastName, companyID) values ('Tome', 'Spencock', 39);
insert into Recruiters (firstName, lastName, companyID) values ('Vida', 'Rosenfeld', 40);

-- Insert Sample Data into Jobs
insert into jobs (position, description, startDate, endDate, recID) values ('Software Engineer', 'Design and implement software solutions', '2024-06-18', '2025-09-23', 1);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Analyze and optimize algorithms', '2024-10-31', '2025-11-17', 2);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Collaborate with team members on projects', '2024-02-04', '2024-02-13', 3);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Design and implement software solutions', '2024-09-29', '2024-02-12', 4);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Collaborate with team members on projects', '2025-08-12', '2024-12-01', 5);
insert into jobs (position, description, startDate, endDate, recID) values ('Software Engineer', 'Design and implement software solutions', '2025-07-09', '2024-12-24', 6);
insert into jobs (position, description, startDate, endDate, recID) values ('Network Administrator', 'Analyze and optimize algorithms', '2024-09-06', '2024-05-06', 7);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Analyze and optimize algorithms', '2023-12-08', '2024-07-03', 8);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Design and implement software solutions', '2024-06-14', '2025-10-27', 9);
insert into jobs (position, description, startDate, endDate, recID) values ('Network Administrator', 'Research new technologies and trends in computer science', '2024-03-17', '2025-05-21', 10);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Analyze and optimize algorithms', '2024-04-15', '2024-04-14', 11);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Analyze and optimize algorithms', '2024-06-20', '2025-07-11', 12);
insert into jobs (position, description, startDate, endDate, recID) values ('Network Administrator', 'Design and implement software solutions', '2024-12-17', '2025-08-07', 13);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Design and implement software solutions', '2024-07-15', '2025-11-13', 14);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Design and implement software solutions', '2024-05-21', '2025-06-01', 15);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Design and implement software solutions', '2024-11-29', '2024-01-02', 16);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Collaborate with team members on projects', '2024-08-21', '2025-05-16', 17);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Analyze and optimize algorithms', '2025-06-24', '2025-06-13', 18);
insert into jobs (position, description, startDate, endDate, recID) values ('Software Engineer', 'Research new technologies and trends in computer science', '2024-09-26', '2025-08-10', 19);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Collaborate with team members on projects', '2025-06-12', '2025-01-15', 20);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Collaborate with team members on projects', '2024-06-04', '2025-05-12', 21);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Analyze and optimize algorithms', '2024-02-15', '2024-08-15', 22);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Research new technologies and trends in computer science', '2025-07-07', '2024-08-06', 23);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Research new technologies and trends in computer science', '2025-01-13', '2025-02-23', 24);
insert into jobs (position, description, startDate, endDate, recID) values ('Network Administrator', 'Design and implement software solutions', '2025-05-26', '2025-08-14', 25);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Research new technologies and trends in computer science', '2024-12-06', '2024-02-01', 26);
insert into jobs (position, description, startDate, endDate, recID) values ('Software Engineer', 'Collaborate with team members on projects', '2024-12-11', '2024-12-24', 27);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Design and implement software solutions', '2024-11-10', '2024-01-07', 28);
insert into jobs (position, description, startDate, endDate, recID) values ('Network Administrator', 'Collaborate with team members on projects', '2024-04-01', '2025-03-15', 29);
insert into jobs (position, description, startDate, endDate, recID) values ('Software Engineer', 'Collaborate with team members on projects', '2024-05-10', '2024-05-27', 30);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Analyze and optimize algorithms', '2025-10-08', '2024-03-06', 31);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Design and implement software solutions', '2025-01-06', '2025-01-24', 32);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Research new technologies and trends in computer science', '2024-11-01', '2024-09-16', 33);
insert into jobs (position, description, startDate, endDate, recID) values ('Software Engineer', 'Collaborate with team members on projects', '2024-10-23', '2025-09-09', 34);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Analyze and optimize algorithms', '2024-02-04', '2025-07-12', 35);
insert into jobs (position, description, startDate, endDate, recID) values ('Data Analyst', 'Research new technologies and trends in computer science', '2025-05-30', '2024-01-02', 36);
insert into jobs (position, description, startDate, endDate, recID) values ('Web Developer', 'Collaborate with team members on projects', '2024-04-17', '2025-02-14', 37);
insert into jobs (position, description, startDate, endDate, recID) values ('IT Specialist', 'Research new technologies and trends in computer science', '2024-09-18', '2024-11-02', 38);
insert into jobs (position, description, startDate, endDate, recID) values ('Network Administrator', 'Collaborate with team members on projects', '2024-08-26', '2025-03-09', 39);
insert into jobs (position, description, startDate, endDate, recID) values ('Software Engineer', 'Analyze and optimize algorithms', '2024-05-16', '2025-01-29', 40);

-- Insert Sample Data into Skills
INSERT INTO skills (name, description, category)
VALUES
('Data Analysis', 'Analyzing datasets', 'Data Science'),
('Prototyping', 'Creating and testing prototypes', 'Mechanical');
insert into skills (name, description, category) values ('Big Data', 'Databases', 'Data Analysis');
insert into skills (name, description, category) values ('Node.js', 'Databases', 'Cybersecurity');
insert into skills (name, description, category) values ('React', 'Databases', 'Database Management');
insert into skills (name, description, category) values ('Vue.js', 'Machine Learning', 'Cybersecurity');
insert into skills (name, description, category) values ('Data Science', 'Databases', 'Database Management');
insert into skills (name, description, category) values ('Jira', 'Algorithms', 'Networking');
insert into skills (name, description, category) values ('Redux', 'Operating Systems', 'Web Development');
insert into skills (name, description, category) values ('Kubernetes', 'Algorithms', 'Database Management');
insert into skills (name, description, category) values ('SQL', 'Machine Learning', 'Web Development');
insert into skills (name, description, category) values ('Cybersecurity', 'Web Development', 'Database Management');
insert into skills (name, description, category) values ('Python', 'Networking', 'Database Management');
insert into skills (name, description, category) values ('SASS', 'Databases', 'Programming');
insert into skills (name, description, category) values ('Agile', 'Databases', 'Data Analysis');
insert into skills (name, description, category) values ('Docker', 'Networking', 'Database Management');
insert into skills (name, description, category) values ('Ruby', 'Web Development', 'Networking');
insert into skills (name, description, category) values ('CSS', 'Networking', 'Programming');
insert into skills (name, description, category) values ('Git', 'Data Structures', 'Programming');
insert into skills (name, description, category) values ('AWS', 'Programming Languages', 'Web Development');
insert into skills (name, description, category) values ('Scrum', 'Operating Systems', 'Database Management');
insert into skills (name, description, category) values ('Bootstrap', 'Programming Languages', 'Networking');
insert into skills (name, description, category) values ('Machine Learning', 'Machine Learning', 'Web Development');
insert into skills (name, description, category) values ('Deep Learning', 'Data Structures', 'Programming');
insert into skills (name, description, category) values ('Firebase', 'Algorithms', 'Programming');
insert into skills (name, description, category) values ('PHP', 'Databases', 'Programming');
insert into skills (name, description, category) values ('C++', 'Algorithms', 'Cybersecurity');
insert into skills (name, description, category) values ('Java', 'Networking', 'Programming');
insert into skills (name, description, category) values ('PyTorch', 'Programming Languages', 'Programming');
insert into skills (name, description, category) values ('GraphQL', 'Data Structures', 'Data Analysis');
insert into skills (name, description, category) values ('Angular', 'Programming Languages', 'Data Analysis');

-- Insert Sample Data into Student Skills
insert into studentSkills (studentID, name, proficiency) values (1, 'Angular', 2);
insert into studentSkills (studentID, name, proficiency) values (2, 'C++', 1);
insert into studentSkills (studentID, name, proficiency) values (3, 'Ruby', 4);
insert into studentSkills (studentID, name, proficiency) values (4, 'C++', 4);
insert into studentSkills (studentID, name, proficiency) values (5, 'SASS', 2);
insert into studentSkills (studentID, name, proficiency) values (6, 'React', 3);
insert into studentSkills (studentID, name, proficiency) values (7, 'Node.js', 3);
insert into studentSkills (studentID, name, proficiency) values (8, 'Firebase', 3);
insert into studentSkills (studentID, name, proficiency) values (9, 'C++', 3);
insert into studentSkills (studentID, name, proficiency) values (10, 'Java', 5);
insert into studentSkills (studentID, name, proficiency) values (11, 'Ruby', 3);
insert into studentSkills (studentID, name, proficiency) values (12, 'Python', 2);
insert into studentSkills (studentID, name, proficiency) values (13, 'CSS', 1);
insert into studentSkills (studentID, name, proficiency) values (14, 'C++', 5);
insert into studentSkills (studentID, name, proficiency) values (15, 'Python', 1);
insert into studentSkills (studentID, name, proficiency) values (16, 'C++', 2);
insert into studentSkills (studentID, name, proficiency) values (17, 'SQL', 1);
insert into studentSkills (studentID, name, proficiency) values (18, 'Big Data', 3);
insert into studentSkills (studentID, name, proficiency) values (19, 'Python', 2);
insert into studentSkills (studentID, name, proficiency) values (20, 'Bootstrap', 3);
insert into studentSkills (studentID, name, proficiency) values (21, 'Java', 3);
insert into studentSkills (studentID, name, proficiency) values (22, 'Redux', 1);
insert into studentSkills (studentID, name, proficiency) values (23, 'Java', 3);
insert into studentSkills (studentID, name, proficiency) values (24, 'Redux', 3);
insert into studentSkills (studentID, name, proficiency) values (25, 'Java', 4);
insert into studentSkills (studentID, name, proficiency) values (26, 'Git', 5);
insert into studentSkills (studentID, name, proficiency) values (27, 'CSS', 1);
insert into studentSkills (studentID, name, proficiency) values (28, 'Ruby', 5);
insert into studentSkills (studentID, name, proficiency) values (29, 'AWS', 3);
insert into studentSkills (studentID, name, proficiency) values (30, 'C++', 4);
insert into studentSkills (studentID, name, proficiency) values (31, 'Cybersecurity', 1);
insert into studentSkills (studentID, name, proficiency) values (32, 'Python', 4);
insert into studentSkills (studentID, name, proficiency) values (33, 'Java', 2);
insert into studentSkills (studentID, name, proficiency) values (34, 'Java', 5);
insert into studentSkills (studentID, name, proficiency) values (35, 'CSS', 5);
insert into studentSkills (studentID, name, proficiency) values (36, 'PHP', 1);
insert into studentSkills (studentID, name, proficiency) values (37, 'Java', 4);
insert into studentSkills (studentID, name, proficiency) values (38, 'C++', 5);
insert into studentSkills (studentID, name, proficiency) values (39, 'Python', 1);
insert into studentSkills (studentID, name, proficiency) values (40, 'C++', 1);

-- Insert Sample Data into Job Skills
insert into jobsSkills (jobID, name, proficiency) values (1, 'CSS', 3);
insert into jobsSkills (jobID, name, proficiency) values (2, 'PHP', 4);
insert into jobsSkills (jobID, name, proficiency) values (3, 'SQL', 3);
insert into jobsSkills (jobID, name, proficiency) values (4, 'SQL', 4);
insert into jobsSkills (jobID, name, proficiency) values (5, 'AWS', 4);
insert into jobsSkills (jobID, name, proficiency) values (6, 'Firebase', 2);
insert into jobsSkills (jobID, name, proficiency) values (7, 'Agile', 4);
insert into jobsSkills (jobID, name, proficiency) values (8, 'AWS', 2);
insert into jobsSkills (jobID, name, proficiency) values (9, 'AWS', 3);
insert into jobsSkills (jobID, name, proficiency) values (10, 'Firebase', 2);
insert into jobsSkills (jobID, name, proficiency) values (11, 'PHP', 5);
insert into jobsSkills (jobID, name, proficiency) values (12, 'SQL', 1);
insert into jobsSkills (jobID, name, proficiency) values (13, 'CSS', 2);
insert into jobsSkills (jobID, name, proficiency) values (14, 'PHP', 2);
insert into jobsSkills (jobID, name, proficiency) values (15, 'Agile', 5);
insert into jobsSkills (jobID, name, proficiency) values (16, 'AWS', 2);
insert into jobsSkills (jobID, name, proficiency) values (17, 'PHP', 4);
insert into jobsSkills (jobID, name, proficiency) values (18, 'AWS', 1);
insert into jobsSkills (jobID, name, proficiency) values (19, 'Agile', 3);
insert into jobsSkills (jobID, name, proficiency) values (20, 'PHP', 5);
insert into jobsSkills (jobID, name, proficiency) values (21, 'Git', 3);
insert into jobsSkills (jobID, name, proficiency) values (22, 'PHP', 3);
insert into jobsSkills (jobID, name, proficiency) values (23, 'AWS', 1);
insert into jobsSkills (jobID, name, proficiency) values (24, 'PHP', 5);
insert into jobsSkills (jobID, name, proficiency) values (25, 'Git', 1);
insert into jobsSkills (jobID, name, proficiency) values (26, 'Agile', 2);
insert into jobsSkills (jobID, name, proficiency) values (27, 'CSS', 5);
insert into jobsSkills (jobID, name, proficiency) values (28, 'CSS', 3);
insert into jobsSkills (jobID, name, proficiency) values (29, 'Git', 1);
insert into jobsSkills (jobID, name, proficiency) values (30, 'C++', 1);
insert into jobsSkills (jobID, name, proficiency) values (31, 'C++', 1);
insert into jobsSkills (jobID, name, proficiency) values (32, 'SQL', 3);
insert into jobsSkills (jobID, name, proficiency) values (33, 'Java', 5);
insert into jobsSkills (jobID, name, proficiency) values (34, 'Agile', 5);
insert into jobsSkills (jobID, name, proficiency) values (35, 'Git', 5);
insert into jobsSkills (jobID, name, proficiency) values (36, 'Firebase', 1);
insert into jobsSkills (jobID, name, proficiency) values (37, 'SQL', 1);
insert into jobsSkills (jobID, name, proficiency) values (38, 'CSS', 4);
insert into jobsSkills (jobID, name, proficiency) values (39, 'Firebase', 5);
insert into jobsSkills (jobID, name, proficiency) values (40, 'Firebase', 3);

-- Insert Sample Data into Applications
insert into application (studentID, jobID, matchPercent, status) values (7, 7, 44, 'Accepted');
insert into application (studentID, jobID, matchPercent, status) values (15, 17, 84, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (11, 18, 78, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (27, 30, 35, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (8, 26, 22, 'Accepted');
insert into application (studentID, jobID, matchPercent, status) values (36, 29, 89, 'Rejected');
insert into application (studentID, jobID, matchPercent, status) values (1, 10, 46, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (33, 7, 11, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (34, 22, 76, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (13, 2, 44, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (17, 16, 56, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (14, 32, 74, 'Accepted');
insert into application (studentID, jobID, matchPercent, status) values (27, 35, 36, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (32, 7, 42, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (39, 12, 67, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (26, 22, 21, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (13, 19, 75, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (37, 2, 77, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (21, 39, 98, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (40, 15, 60, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (2, 32, 55, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (33, 11, 94, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (24, 30, 46, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (36, 5, 63, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (20, 5, 48, 'Accepted');
insert into application (studentID, jobID, matchPercent, status) values (14, 13, 49, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (13, 16, 52, 'Accepted');
insert into application (studentID, jobID, matchPercent, status) values (1, 9, 86, 'Rejected');
insert into application (studentID, jobID, matchPercent, status) values (33, 30, 42, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (10, 22, 43, 'Accepted');
insert into application (studentID, jobID, matchPercent, status) values (35, 23, 31, 'Accepted');
insert into application (studentID, jobID, matchPercent, status) values (26, 12, 3, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (34, 30, 61, 'Rejected');
insert into application (studentID, jobID, matchPercent, status) values (35, 30, 65, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (24, 7, 74, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (19, 40, 71, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (19, 37, 75, 'Rejected');
insert into application (studentID, jobID, matchPercent, status) values (11, 9, 39, 'Interviewing');
insert into application (studentID, jobID, matchPercent, status) values (19, 18, 26, 'Submitted');
insert into application (studentID, jobID, matchPercent, status) values (18, 1, 92, 'Rejected');

-- Insert Sample Data into Experiences
insert into experiences (title, Username, review, rating, jobID) values ('Cybersecurity Analyst', 26, 'long hours', 5, 36);
insert into experiences (title, Username, review, rating, jobID) values ('Data Scientist', 32, 'High stress levels', 4, 40);
insert into experiences (title, Username, review, rating, jobID) values ('Systems Analyst', 5, 'opportunity for growth', 1, 21);
insert into experiences (title, Username, review, rating, jobID) values ('Data Scientist', 37, 'challenging projects', 2, 36);
insert into experiences (title, Username, review, rating, jobID) values ('Data Scientist', 37, 'Good team collaboration', 4, 16);
insert into experiences (title, Username, review, rating, jobID) values ('Web Developer', 4, 'cutting-edge technologies', 1, 23);
insert into experiences (title, Username, review, rating, jobID) values ('Network Administrator', 17, 'Good team collaboration', 3, 16);
insert into experiences (title, Username, review, rating, jobID) values ('Software Engineer', 26, 'Good team collaboration', 5, 27);
insert into experiences (title, Username, review, rating, jobID) values ('IT Specialist', 27, 'opportunity for growth', 5, 10);
insert into experiences (title, Username, review, rating, jobID) values ('Cybersecurity Analyst', 10, 'cutting-edge technologies', 3, 26);
insert into experiences (title, Username, review, rating, jobID) values ('IT Specialist', 26, 'challenging projects', 2, 5);
insert into experiences (title, Username, review, rating, jobID) values ('Database Administrator', 35, 'Great work environment', 1, 38);
insert into experiences (title, Username, review, rating, jobID) values ('Network Administrator', 32, 'cutting-edge technologies', 2, 15);
insert into experiences (title, Username, review, rating, jobID) values ('Network Administrator', 34, 'Great work environment', 5, 5);
insert into experiences (title, Username, review, rating, jobID) values ('Web Developer', 2, 'Good team collaboration', 1, 24);
insert into experiences (title, Username, review, rating, jobID) values ('IT Specialist', 4, 'High stress levels', 1, 14);
insert into experiences (title, Username, review, rating, jobID) values ('Data Scientist', 22, 'Good team collaboration', 5, 35);
insert into experiences (title, Username, review, rating, jobID) values ('Systems Analyst', 26, 'long hours', 4, 33);
insert into experiences (title, Username, review, rating, jobID) values ('Cybersecurity Analyst', 33, 'opportunity for growth', 5, 19);
insert into experiences (title, Username, review, rating, jobID) values ('IT Specialist', 28, 'Innovative company culture', 3, 27);
insert into experiences (title, Username, review, rating, jobID) values ('Systems Analyst', 31, 'Good team collaboration', 3, 27);
insert into experiences (title, Username, review, rating, jobID) values ('IT Specialist', 35, 'High stress levels', 5, 32);
insert into experiences (title, Username, review, rating, jobID) values ('Web Developer', 1, 'challenging projects', 1, 13);
insert into experiences (title, Username, review, rating, jobID) values ('Web Developer', 20, 'opportunity for growth', 3, 32);
insert into experiences (title, Username, review, rating, jobID) values ('Software Engineer', 28, 'High stress levels', 3, 38);
insert into experiences (title, Username, review, rating, jobID) values ('Network Administrator', 16, 'challenging projects', 2, 36);
insert into experiences (title, Username, review, rating, jobID) values ('Systems Analyst', 8, 'cutting-edge technologies', 3, 32);
insert into experiences (title, Username, review, rating, jobID) values ('Network Administrator', 16, 'Great work environment', 3, 23);
insert into experiences (title, Username, review, rating, jobID) values ('Systems Analyst', 5, 'Good team collaboration', 4, 36);
insert into experiences (title, Username, review, rating, jobID) values ('Software Engineer', 30, 'Good team collaboration', 4, 18);
insert into experiences (title, Username, review, rating, jobID) values ('Data Scientist', 20, 'cutting-edge technologies', 5, 17);
insert into experiences (title, Username, review, rating, jobID) values ('Software Engineer', 14, 'opportunity for growth', 2, 15);
insert into experiences (title, Username, review, rating, jobID) values ('Network Administrator', 10, 'Great work environment', 5, 16);
insert into experiences (title, Username, review, rating, jobID) values ('Database Administrator', 40, 'High stress levels', 1, 8);
insert into experiences (title, Username, review, rating, jobID) values ('Cybersecurity Analyst', 19, 'opportunity for growth', 2, 34);
insert into experiences (title, Username, review, rating, jobID) values ('Data Scientist', 34, 'opportunity for growth', 4, 9);
insert into experiences (title, Username, review, rating, jobID) values ('Web Developer', 18, 'opportunity for growth', 2, 5);
insert into experiences (title, Username, review, rating, jobID) values ('Data Scientist', 40, 'High stress levels', 4, 17);
insert into experiences (title, Username, review, rating, jobID) values ('Cybersecurity Analyst', 3, 'cutting-edge technologies', 2, 35);
insert into experiences (title, Username, review, rating, jobID) values ('Software Engineer', 18, 'cutting-edge technologies', 1, 18);

-- Insert Sample Data into BlackListed
insert into BlackListed (recID, studentID) values (37, 33);
insert into BlackListed (recID, studentID) values (34, 5);
insert into BlackListed (recID, studentID) values (11, 29);
insert into BlackListed (recID, studentID) values (7, 9);
insert into BlackListed (recID, studentID) values (15, 9);
insert into BlackListed (recID, studentID) values (28, 5);
insert into BlackListed (recID, studentID) values (19, 1);
insert into BlackListed (recID, studentID) values (30, 2);
insert into BlackListed (recID, studentID) values (32, 37);
insert into BlackListed (recID, studentID) values (35, 13);
insert into BlackListed (recID, studentID) values (18, 13);
insert into BlackListed (recID, studentID) values (10, 37);
insert into BlackListed (recID, studentID) values (1, 34);
insert into BlackListed (recID, studentID) values (1, 35);
insert into BlackListed (recID, studentID) values (23, 38);
insert into BlackListed (recID, studentID) values (26, 32);
insert into BlackListed (recID, studentID) values (4, 12);
insert into BlackListed (recID, studentID) values (21, 1);
insert into BlackListed (recID, studentID) values (11, 26);
insert into BlackListed (recID, studentID) values (27, 19);
insert into BlackListed (recID, studentID) values (28, 17);
insert into BlackListed (recID, studentID) values (38, 4);
insert into BlackListed (recID, studentID) values (29, 21);
insert into BlackListed (recID, studentID) values (26, 6);
insert into BlackListed (recID, studentID) values (35, 19);
insert into BlackListed (recID, studentID) values (11, 35);
insert into BlackListed (recID, studentID) values (23, 30);
insert into BlackListed (recID, studentID) values (33, 39);
insert into BlackListed (recID, studentID) values (21, 27);
insert into BlackListed (recID, studentID) values (15, 35);
insert into BlackListed (recID, studentID) values (18, 2);
insert into BlackListed (recID, studentID) values (32, 16);
insert into BlackListed (recID, studentID) values (16, 9);
insert into BlackListed (recID, studentID) values (13, 14);
insert into BlackListed (recID, studentID) values (6, 33);
insert into BlackListed (recID, studentID) values (27, 39);
insert into BlackListed (recID, studentID) values (12, 4);
insert into BlackListed (recID, studentID) values (20, 14);
insert into BlackListed (recID, studentID) values (30, 15);
insert into BlackListed (recID, studentID) values (3, 27);

-- Insert Sample Data into Department Head
insert into DepartmentHead (firstName, lastName) values ('Bendix', 'Galero');
insert into DepartmentHead (firstName, lastName) values ('Albie', 'Addenbrooke');
insert into DepartmentHead (firstName, lastName) values ('Micheil', 'Waeland');
insert into DepartmentHead (firstName, lastName) values ('Regan', 'Larrosa');
insert into DepartmentHead (firstName, lastName) values ('Arvie', 'Melding');
insert into DepartmentHead (firstName, lastName) values ('Atalanta', 'Watts');
insert into DepartmentHead (firstName, lastName) values ('Travus', 'Saffill');
insert into DepartmentHead (firstName, lastName) values ('Holly-anne', 'Winmill');
insert into DepartmentHead (firstName, lastName) values ('Bel', 'Treadway');
insert into DepartmentHead (firstName, lastName) values ('Arnie', 'Jennions');
insert into DepartmentHead (firstName, lastName) values ('Robena', 'Henstone');
insert into DepartmentHead (firstName, lastName) values ('Lanny', 'Penrith');
insert into DepartmentHead (firstName, lastName) values ('Thorndike', 'Sturge');
insert into DepartmentHead (firstName, lastName) values ('Gamaliel', 'Westraw');
insert into DepartmentHead (firstName, lastName) values ('Rosalinda', 'Foch');
insert into DepartmentHead (firstName, lastName) values ('Hailey', 'Garrud');
insert into DepartmentHead (firstName, lastName) values ('Willi', 'Anthiftle');
insert into DepartmentHead (firstName, lastName) values ('Yelena', 'Treneer');
insert into DepartmentHead (firstName, lastName) values ('Ignacio', 'Ciobutaru');
insert into DepartmentHead (firstName, lastName) values ('Maggy', 'Malinson');
insert into DepartmentHead (firstName, lastName) values ('Johannah', 'McCullock');
insert into DepartmentHead (firstName, lastName) values ('Udale', 'Furminger');
insert into DepartmentHead (firstName, lastName) values ('Martica', 'Hagyard');
insert into DepartmentHead (firstName, lastName) values ('Kim', 'Ferrandez');
insert into DepartmentHead (firstName, lastName) values ('Quentin', 'Woolham');
insert into DepartmentHead (firstName, lastName) values ('Arney', 'Leacy');
insert into DepartmentHead (firstName, lastName) values ('Ara', 'Birkenshaw');
insert into DepartmentHead (firstName, lastName) values ('Baird', 'Di Biagio');
insert into DepartmentHead (firstName, lastName) values ('Lyda', 'Gairdner');
insert into DepartmentHead (firstName, lastName) values ('Devland', 'Wimpeney');
insert into DepartmentHead (firstName, lastName) values ('Kristofer', 'Oulner');
insert into DepartmentHead (firstName, lastName) values ('Karim', 'Jessep');
insert into DepartmentHead (firstName, lastName) values ('Hercules', 'Dowsett');
insert into DepartmentHead (firstName, lastName) values ('Raina', 'McCurley');
insert into DepartmentHead (firstName, lastName) values ('Nelle', 'Doyley');
insert into DepartmentHead (firstName, lastName) values ('Lilah', 'Stanford');
insert into DepartmentHead (firstName, lastName) values ('Marys', 'Gosson');
insert into DepartmentHead (firstName, lastName) values ('Vale', 'Paal');
insert into DepartmentHead (firstName, lastName) values ('Issy', 'Kendred');
insert into DepartmentHead (firstName, lastName) values ('Christina', 'Gaye');

-- Insert Sample Data into Department
insert into Department (name, DH_ID) values ('Information Technology', 1);
insert into Department (name, DH_ID) values ('Computer Science', 2);
insert into Department (name, DH_ID) values ('Software Engineering', 3);
insert into Department (name, DH_ID) values ('Computer Science', 4);
insert into Department (name, DH_ID) values ('Software Engineering', 5);
insert into Department (name, DH_ID) values ('Data Science', 6);
insert into Department (name, DH_ID) values ('Information Technology', 7);
insert into Department (name, DH_ID) values ('Information Technology', 8);
insert into Department (name, DH_ID) values ('Cybersecurity', 9);
insert into Department (name, DH_ID) values ('Software Engineering', 10);
insert into Department (name, DH_ID) values ('Data Science', 11);
insert into Department (name, DH_ID) values ('Data Science', 12);
insert into Department (name, DH_ID) values ('Software Engineering', 13);
insert into Department (name, DH_ID) values ('Computer Science', 14);
insert into Department (name, DH_ID) values ('Cybersecurity', 15);
insert into Department (name, DH_ID) values ('Information Technology', 16);
insert into Department (name, DH_ID) values ('Software Engineering', 17);
insert into Department (name, DH_ID) values ('Data Science', 18);
insert into Department (name, DH_ID) values ('Data Science', 19);
insert into Department (name, DH_ID) values ('Computer Science', 20);
insert into Department (name, DH_ID) values ('Information Technology', 21);
insert into Department (name, DH_ID) values ('Data Science', 22);
insert into Department (name, DH_ID) values ('Computer Science', 23);
insert into Department (name, DH_ID) values ('Software Engineering', 24);
insert into Department (name, DH_ID) values ('Data Science', 25);
insert into Department (name, DH_ID) values ('Data Science', 26);
insert into Department (name, DH_ID) values ('Information Technology', 27);
insert into Department (name, DH_ID) values ('Information Technology', 28);
insert into Department (name, DH_ID) values ('Cybersecurity', 29);
insert into Department (name, DH_ID) values ('Software Engineering', 30);
insert into Department (name, DH_ID) values ('Data Science', 31);
insert into Department (name, DH_ID) values ('Software Engineering', 32);
insert into Department (name, DH_ID) values ('Cybersecurity', 33);
insert into Department (name, DH_ID) values ('Cybersecurity', 34);
insert into Department (name, DH_ID) values ('Computer Science', 35);
insert into Department (name, DH_ID) values ('Data Science', 36);
insert into Department (name, DH_ID) values ('Computer Science', 37);
insert into Department (name, DH_ID) values ('Information Technology', 38);
insert into Department (name, DH_ID) values ('Information Technology', 39);
insert into Department (name, DH_ID) values ('Software Engineering', 40);

-- Insert Sample Data into Courses
insert into Courses (departmentId, name, description) values (1, 'Introduction to Computer Science', 'Data Analytics and Visualization');
insert into Courses (departmentId, name, description) values (2, 'Data Structures and Algorithms', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (3, 'Data Structures and Algorithms', 'Data Analytics and Visualization');
insert into Courses (departmentId, name, description) values (4, 'Introduction to Computer Science', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (5, 'Web Development', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (6, 'Introduction to Computer Science', 'Data Analytics and Visualization');
insert into Courses (departmentId, name, description) values (7, 'Database Management', 'Introduction to Computer Science for Technology Majors');
insert into Courses (departmentId, name, description) values (8, 'Database Management', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (9, 'Data Structures and Algorithms', 'Introduction to Computer Science for Technology Majors');
insert into Courses (departmentId, name, description) values (10, 'Data Structures and Algorithms', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (11, 'Data Structures and Algorithms', 'Data Analytics and Visualization');
insert into Courses (departmentId, name, description) values (12, 'Web Development', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (13, 'Database Management', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (14, 'Cybersecurity Essentials', 'Introduction to Computer Science for Technology Majors');
insert into Courses (departmentId, name, description) values (15, 'Introduction to Computer Science', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (16, 'Data Structures and Algorithms', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (17, 'Introduction to Computer Science', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (18, 'Introduction to Computer Science', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (19, 'Database Management', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (20, 'Data Structures and Algorithms', 'Introduction to Computer Science for Technology Majors');
insert into Courses (departmentId, name, description) values (21, 'Introduction to Computer Science', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (22, 'Introduction to Computer Science', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (23, 'Data Structures and Algorithms', 'Data Analytics and Visualization');
insert into Courses (departmentId, name, description) values (24, 'Web Development', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (25, 'Web Development', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (26, 'Introduction to Computer Science', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (27, 'Web Development', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (28, 'Introduction to Computer Science', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (29, 'Introduction to Computer Science', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (30, 'Web Development', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (31, 'Introduction to Computer Science', 'Introduction to Computer Science for Technology Majors');
insert into Courses (departmentId, name, description) values (32, 'Data Structures and Algorithms', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (33, 'Database Management', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (34, 'Database Management', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (35, 'Data Structures and Algorithms', 'Web Development for Technology Professionals');
insert into Courses (departmentId, name, description) values (36, 'Web Development', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (37, 'Introduction to Computer Science', 'Introduction to Computer Science for Technology Majors');
insert into Courses (departmentId, name, description) values (38, 'Data Structures and Algorithms', 'Cybersecurity Fundamentals');
insert into Courses (departmentId, name, description) values (39, 'Web Development', 'Advanced Database Management');
insert into Courses (departmentId, name, description) values (40, 'Cybersecurity Essentials', 'Advanced Database Management');

-- Insert Sample Data into Course Skills

insert into CourseSkills (courseID, name) values (1, 'Node.js');
insert into CourseSkills (courseID, name) values (2, 'Kubernetes');
insert into CourseSkills (courseID, name) values (3, 'Git');
insert into CourseSkills (courseID, name) values (4, 'Angular');
insert into CourseSkills (courseID, name) values (5, 'Vue.js');
insert into CourseSkills (courseID, name) values (6, 'PyTorch');
insert into CourseSkills (courseID, name) values (7, 'Python');
insert into CourseSkills (courseID, name) values (8, 'Python');
insert into CourseSkills (courseID, name) values (9, 'Cybersecurity');
insert into CourseSkills (courseID, name) values (10, 'SASS');
insert into CourseSkills (courseID, name) values (11, 'Agile');
insert into CourseSkills (courseID, name) values (12, 'Ruby');
insert into CourseSkills (courseID, name) values (13, 'Scrum');
insert into CourseSkills (courseID, name) values (14, 'Angular');
insert into CourseSkills (courseID, name) values (15, 'Git');
insert into CourseSkills (courseID, name) values (16, 'React');
insert into CourseSkills (courseID, name) values (17, 'Kubernetes');
insert into CourseSkills (courseID, name) values (18, 'Deep Learning');
insert into CourseSkills (courseID, name) values (19, 'PyTorch');
insert into CourseSkills (courseID, name) values (20, 'Docker');
insert into CourseSkills (courseID, name) values (21, 'GraphQL');
insert into CourseSkills (courseID, name) values (22, 'SQL');
insert into CourseSkills (courseID, name) values (23, 'Node.js');
insert into CourseSkills (courseID, name) values (24, 'Ruby');
insert into CourseSkills (courseID, name) values (25, 'Data Science');
insert into CourseSkills (courseID, name) values (26, 'React');
insert into CourseSkills (courseID, name) values (27, 'CSS');
insert into CourseSkills (courseID, name) values (28, 'Python');
insert into CourseSkills (courseID, name) values (29, 'AWS');
insert into CourseSkills (courseID, name) values (30, 'SASS');
insert into CourseSkills (courseID, name) values (31, 'Firebase');
insert into CourseSkills (courseID, name) values (32, 'GraphQL');
insert into CourseSkills (courseID, name) values (33, 'Angular');
insert into CourseSkills (courseID, name) values (34, 'Data Science');
insert into CourseSkills (courseID, name) values (35, 'Agile');
insert into CourseSkills (courseID, name) values (36, 'Ruby');
insert into CourseSkills (courseID, name) values (37, 'PyTorch');
insert into CourseSkills (courseID, name) values (38, 'C++');
insert into CourseSkills (courseID, name) values (39, 'Ruby');
insert into CourseSkills (courseID, name) values (40, 'Deep Learning');

-- Insert Sample Data into Notes
insert into Notes (userID, content) values (1, 'Prepare for interviews');
insert into Notes (userID, content) values (2, 'Network with professionals');
insert into Notes (userID, content) values (3, 'Update your resume');
insert into Notes (userID, content) values (4, 'Update your resume');
insert into Notes (userID, content) values (5, 'Research companies');
insert into Notes (userID, content) values (6, 'Update your resume');
insert into Notes (userID, content) values (7, 'Network with professionals');
insert into Notes (userID, content) values (8, 'Update your resume');
insert into Notes (userID, content) values (9, 'Update your resume');
insert into Notes (userID, content) values (10, 'Prepare for interviews');
insert into Notes (userID, content) values (11, 'Apply to multiple positions');
insert into Notes (userID, content) values (12, 'Network with professionals');
insert into Notes (userID, content) values (13, 'Update your resume');
insert into Notes (userID, content) values (14, 'Apply to multiple positions');
insert into Notes (userID, content) values (15, 'Prepare for interviews');
insert into Notes (userID, content) values (16, 'Prepare for interviews');
insert into Notes (userID, content) values (17, 'Network with professionals');
insert into Notes (userID, content) values (18, 'Apply to multiple positions');
insert into Notes (userID, content) values (19, 'Prepare for interviews');
insert into Notes (userID, content) values (20, 'Research companies');
insert into Notes (userID, content) values (21, 'Update your resume');
insert into Notes (userID, content) values (22, 'Network with professionals');
insert into Notes (userID, content) values (23, 'Network with professionals');
insert into Notes (userID, content) values (24, 'Apply to multiple positions');
insert into Notes (userID, content) values (25, 'Network with professionals');
insert into Notes (userID, content) values (26, 'Apply to multiple positions');
insert into Notes (userID, content) values (27, 'Update your resume');
insert into Notes (userID, content) values (28, 'Update your resume');
insert into Notes (userID, content) values (29, 'Apply to multiple positions');
insert into Notes (userID, content) values (30, 'Apply to multiple positions');
insert into Notes (userID, content) values (31, 'Update your resume');
insert into Notes (userID, content) values (32, 'Prepare for interviews');
insert into Notes (userID, content) values (33, 'Network with professionals');
insert into Notes (userID, content) values (34, 'Research companies');
insert into Notes (userID, content) values (35, 'Apply to multiple positions');
insert into Notes (userID, content) values (36, 'Prepare for interviews');
insert into Notes (userID, content) values (37, 'Prepare for interviews');
insert into Notes (userID, content) values (38, 'Update your resume');
insert into Notes (userID, content) values (39, 'Network with professionals');
insert into Notes (userID, content) values (40, 'Update your resume');


-- Insert Sample Data into Developer
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('vpuddin0', 'Vannie', 'Puddin', 'Database Administrator', 'Intermediate');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('nlongman1', 'Nadeen', 'Longman', 'Database Administrator', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('lhebburn2', 'Lenard', 'Hebburn', 'Network Administrator', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('tmacconchie3', 'Tildie', 'MacConchie', 'Cybersecurity Specialist', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('wliell4', 'Wilburt', 'Liell', 'Cybersecurity Specialist', 'Senior');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('epossa5', 'Elora', 'Possa', 'Cybersecurity Specialist', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('zbris6', 'Zorah', 'Bris', 'Data Analyst', 'Senior');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('ameadmore7', 'Antone', 'Meadmore', 'Cybersecurity Specialist', 'Intermediate');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('ymatsell8', 'Yolanda', 'Matsell', 'Data Analyst', 'Intermediate');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('rhollindale9', 'Rene', 'Hollindale', 'Database Administrator', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('lwarsopa', 'Lefty', 'Warsop', 'Data Analyst', 'Advanced');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('rpaliab', 'Roda', 'Palia', 'Data Analyst', 'Senior');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('kreisenbergc', 'Karlotte', 'Reisenberg', 'Software Engineer', 'Intermediate');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('lhanlind', 'Leia', 'Hanlin', 'Network Administrator', 'Senior');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('shalme', 'Sayres', 'Halm', 'Software Engineer', 'Senior');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('escutterf', 'Elwin', 'Scutter', 'Network Administrator', 'Intermediate');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('bgaraghang', 'Bertha', 'Garaghan', 'Network Administrator', 'Advanced');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('sbenardetteh', 'Seth', 'Benardette', 'Network Administrator', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('krumgayi', 'Kaleena', 'Rumgay', 'Cybersecurity Specialist', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('lswinnardj', 'Lenard', 'Swinnard', 'Data Analyst', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('gkelingk', 'Genevra', 'Keling', 'Network Administrator', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('bshercliffl', 'Bentlee', 'Shercliff', 'Data Analyst', 'Senior');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('mroderickm', 'Mordecai', 'Roderick', 'Software Engineer', 'Advanced');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('mjoblingn', 'Marlowe', 'Jobling', 'Cybersecurity Specialist', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('ebarlowo', 'Erda', 'Barlow', 'Network Administrator', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('ereynishp', 'Elmira', 'Reynish', 'Cybersecurity Specialist', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('abrugmanq', 'Anetta', 'Brugman', 'Database Administrator', 'Senior');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('fbreetonr', 'Fletch', 'Breeton', 'Network Administrator', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('narters', 'Nanette', 'Arter', 'Data Analyst', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('ogallantt', 'Ofelia', 'Gallant', 'Data Analyst', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('cwrixonu', 'Cale', 'Wrixon', 'Data Analyst', 'Intermediate');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('tdoreyv', 'Tove', 'Dorey', 'Data Analyst', 'Beginner');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('acoullingw', 'Arturo', 'Coulling', 'Data Analyst', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('vmatityahux', 'Valene', 'Matityahu', 'Software Engineer', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('fhurticy', 'Fayre', 'Hurtic', 'Data Analyst', 'Advanced');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('ckervinz', 'Chance', 'Kervin', 'Software Engineer', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('nkrikorian10', 'Nobie', 'Krikorian', 'Software Engineer', 'Expert');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('mrumbellow11', 'Maryellen', 'Rumbellow', 'Data Analyst', 'Advanced');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('khoodless12', 'Kelsy', 'Hoodless', 'Cybersecurity Specialist', 'Intermediate');
insert into Developer (username, firstName, lastName, role, experienceLevel) values ('jbrant13', 'Jules', 'Brant', 'Database Administrator', 'Advanced');


insert into Website (name, version, status) values ('NU Pathfinder', 'v1.0', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.0', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.1', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.0', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.1', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.1', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.0', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.1', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.1', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.1', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.1', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.1', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.2', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.1', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.1', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.2', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.0', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.0', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.2', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.1', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.0', 'active');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.1', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.0', 'inactive');
insert into Website (name, version, status) values ('NU Pathfinder', 'v2.2', 'maintenance');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'error');
insert into Website (name, version, status) values ('NU Pathfinder', 'v1.2', 'inactive');

-- Insert Sample Data into Documentation
insert into Documentation (section, details, lastUpdated, developerID) values ('Machine Learning', 'Develop software applications and solutions', '2024-05-08', 18);
insert into Documentation (section, details, lastUpdated, developerID) values ('Code Review', 'Design and maintain network infrastructure for communication and data transfer', '2024-05-21', 2);
insert into Documentation (section, details, lastUpdated, developerID) values ('Bug Tracking', 'Develop software applications and solutions', '2024-08-26', 2);
insert into Documentation (section, details, lastUpdated, developerID) values ('User Experience', 'Design and maintain network infrastructure for communication and data transfer', '2025-07-12', 23);
insert into Documentation (section, details, lastUpdated, developerID) values ('Data Visualization', 'Design and maintain network infrastructure for communication and data transfer', '2025-04-04', 39);
insert into Documentation (section, details, lastUpdated, developerID) values ('Scripting', 'Manage and maintain databases to ensure data integrity and availability', '2024-06-10', 40);
insert into Documentation (section, details, lastUpdated, developerID) values ('Networking', 'Test and ensure the quality of software products', '2025-04-17', 2);
insert into Documentation (section, details, lastUpdated, developerID) values ('Natural Language Processing', 'Test and ensure the quality of software products', '2025-02-11', 13);
insert into Documentation (section, details, lastUpdated, developerID) values ('Security', 'Manage and maintain databases to ensure data integrity and availability', '2025-06-07', 1);
insert into Documentation (section, details, lastUpdated, developerID) values ('Big Data', 'Plan and oversee projects to ensure they are completed successfully', '2024-10-09', 12);
insert into Documentation (section, details, lastUpdated, developerID) values ('User Experience', 'Develop software applications and solutions', '2025-03-25', 31);
insert into Documentation (section, details, lastUpdated, developerID) values ('Virtual Reality', 'Develop software applications and solutions', '2025-09-02', 17);
insert into Documentation (section, details, lastUpdated, developerID) values ('Performance Optimization', 'Plan and oversee projects to ensure they are completed successfully', '2024-10-01', 11);
insert into Documentation (section, details, lastUpdated, developerID) values ('Version Control', 'Design and maintain network infrastructure for communication and data transfer', '2024-03-20', 2);
insert into Documentation (section, details, lastUpdated, developerID) values ('Networking', 'Design and maintain network infrastructure for communication and data transfer', '2024-04-03', 31);
insert into Documentation (section, details, lastUpdated, developerID) values ('Web Development', 'Manage and maintain databases to ensure data integrity and availability', '2025-02-21', 3);
insert into Documentation (section, details, lastUpdated, developerID) values ('Augmented Reality', 'Manage and maintain databases to ensure data integrity and availability', '2025-07-02', 1);
insert into Documentation (section, details, lastUpdated, developerID) values ('Natural Language Processing', 'Design and maintain network infrastructure for communication and data transfer', '2024-02-26', 35);
insert into Documentation (section, details, lastUpdated, developerID) values ('Virtual Reality', 'Plan and oversee projects to ensure they are completed successfully', '2024-06-17', 17);
insert into Documentation (section, details, lastUpdated, developerID) values ('Cryptocurrency', 'Develop software applications and solutions', '2025-03-22', 40);
insert into Documentation (section, details, lastUpdated, developerID) values ('Blockchain', 'Design and maintain network infrastructure for communication and data transfer', '2024-04-15', 12);
insert into Documentation (section, details, lastUpdated, developerID) values ('IoT', 'Develop software applications and solutions', '2024-07-21', 7);
insert into Documentation (section, details, lastUpdated, developerID) values ('Logging', 'Manage and maintain databases to ensure data integrity and availability', '2025-09-12', 13);
insert into Documentation (section, details, lastUpdated, developerID) values ('API Integration', 'Test and ensure the quality of software products', '2025-09-07', 5);
insert into Documentation (section, details, lastUpdated, developerID) values ('Blockchain', 'Plan and oversee projects to ensure they are completed successfully', '2025-02-26', 14);
insert into Documentation (section, details, lastUpdated, developerID) values ('Virtual Reality', 'Plan and oversee projects to ensure they are completed successfully', '2025-04-21', 21);
insert into Documentation (section, details, lastUpdated, developerID) values ('Cross-platform Development', 'Plan and oversee projects to ensure they are completed successfully', '2025-02-01', 3);
insert into Documentation (section, details, lastUpdated, developerID) values ('Code Review', 'Test and ensure the quality of software products', '2024-10-13', 31);
insert into Documentation (section, details, lastUpdated, developerID) values ('Data Visualization', 'Design and maintain network infrastructure for communication and data transfer', '2025-02-27', 16);
insert into Documentation (section, details, lastUpdated, developerID) values ('Data Visualization', 'Test and ensure the quality of software products', '2025-02-25', 32);
insert into Documentation (section, details, lastUpdated, developerID) values ('Augmented Reality', 'Plan and oversee projects to ensure they are completed successfully', '2025-11-14', 30);
insert into Documentation (section, details, lastUpdated, developerID) values ('Data Analysis', 'Manage and maintain databases to ensure data integrity and availability', '2025-01-15', 8);
insert into Documentation (section, details, lastUpdated, developerID) values ('Version Control', 'Test and ensure the quality of software products', '2025-09-08', 34);
insert into Documentation (section, details, lastUpdated, developerID) values ('Bug Tracking', 'Plan and oversee projects to ensure they are completed successfully', '2025-08-21', 4);
insert into Documentation (section, details, lastUpdated, developerID) values ('User Experience', 'Design and maintain network infrastructure for communication and data transfer', '2025-05-25', 24);
insert into Documentation (section, details, lastUpdated, developerID) values ('Machine Learning', 'Manage and maintain databases to ensure data integrity and availability', '2024-03-21', 18);
insert into Documentation (section, details, lastUpdated, developerID) values ('Backup and Recovery', 'Develop software applications and solutions', '2024-11-12', 40);
insert into Documentation (section, details, lastUpdated, developerID) values ('Scripting', 'Develop software applications and solutions', '2025-03-13', 17);
insert into Documentation (section, details, lastUpdated, developerID) values ('Mobile Development', 'Manage and maintain databases to ensure data integrity and availability', '2025-07-21', 22);
insert into Documentation (section, details, lastUpdated, developerID) values ('Web Development', 'Develop software applications and solutions', '2024-09-09', 2);

-- Insert Sample Data into Feature
insert into Feature (name, description, status) values ('rating feature', 'sort', 'Scrapped');
insert into Feature (name, description, status) values ('comment feature', 'dark mode', 'Active');
insert into Feature (name, description, status) values ('download feature', 'upload', 'Active');
insert into Feature (name, description, status) values ('gesture control feature', 'payment', 'Testing');
insert into Feature (name, description, status) values ('reporting feature', 'sharing', 'Active');
insert into Feature (name, description, status) values ('filter feature', 'offline mode', 'Scrapped');
insert into Feature (name, description, status) values ('calendar feature', 'analytics', 'Testing');
insert into Feature (name, description, status) values ('download feature', 'accessibility', 'Testing');
insert into Feature (name, description, status) values ('filter feature', 'sync', 'Testing');
insert into Feature (name, description, status) values ('reporting feature', 'light mode', 'Scrapped');
insert into Feature (name, description, status) values ('analytics feature', 'analytics', 'Testing');
insert into Feature (name, description, status) values ('multi-language support feature', 'gesture control', 'Active');
insert into Feature (name, description, status) values ('calendar feature', 'accessibility', 'Testing');
insert into Feature (name, description, status) values ('accessibility feature', 'comment', 'Active');
insert into Feature (name, description, status) values ('backup feature', 'notification', 'Active');
insert into Feature (name, description, status) values ('payment feature', 'payment', 'Active');
insert into Feature (name, description, status) values ('login feature', 'analytics', 'Testing');
insert into Feature (name, description, status) values ('offline mode feature', 'chat', 'Testing');
insert into Feature (name, description, status) values ('calendar feature', 'rating', 'Scrapped');
insert into Feature (name, description, status) values ('voice command feature', 'customization', 'Active');
insert into Feature (name, description, status) values ('search feature', 'dark mode', 'Scrapped');
insert into Feature (name, description, status) values ('dark mode feature', 'calendar', 'Testing');
insert into Feature (name, description, status) values ('sync feature', 'settings', 'Testing');
insert into Feature (name, description, status) values ('analytics feature', 'reporting', 'Testing');
insert into Feature (name, description, status) values ('map feature', 'chat', 'Testing');
insert into Feature (name, description, status) values ('gesture control feature', 'multi-language support', 'Active');
insert into Feature (name, description, status) values ('profile feature', 'integration', 'Testing');
insert into Feature (name, description, status) values ('like feature', 'sync', 'Scrapped');
insert into Feature (name, description, status) values ('profile feature', 'integration', 'Scrapped');
insert into Feature (name, description, status) values ('integration feature', 'reporting', 'Scrapped');
insert into Feature (name, description, status) values ('download feature', 'analytics', 'Scrapped');
insert into Feature (name, description, status) values ('sync feature', 'backup', 'Active');
insert into Feature (name, description, status) values ('offline mode feature', 'multi-language support', 'Active');
insert into Feature (name, description, status) values ('sort feature', 'login', 'Testing');
insert into Feature (name, description, status) values ('sort feature', 'offline mode', 'Scrapped');
insert into Feature (name, description, status) values ('analytics feature', 'dark mode', 'Scrapped');
insert into Feature (name, description, status) values ('comment feature', 'map', 'Active');
insert into Feature (name, description, status) values ('backup feature', 'filter', 'Testing');
insert into Feature (name, description, status) values ('profile feature', 'map', 'Scrapped');
insert into Feature (name, description, status) values ('notification feature', 'multi-language support', 'Testing');

-- Insert Sample Data into UserFeedback
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (28, 31, 5, 'The app crashes frequently and needs improvement.', '2024-06-27', 16);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (13, 30, 5, 'I wish the app had more customization options.', '2024-07-06', 24);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (9, 14, 1, 'This app is amazing!', '2024-10-05', 25);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (17, 3, 5, 'I wish the app had more customization options.', '2025-03-30', 19);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (31, 37, 4, 'This app is amazing!', '2024-05-19', 10);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (21, 31, 1, 'This app is amazing!', '2025-08-28', 36);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (1, 26, 5, 'This app is amazing!', '2024-04-23', 27);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (6, 39, 1, 'The app is user-friendly and efficient.', '2024-02-15', 23);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (30, 19, 2, 'I love the new features added.', '2025-04-03', 6);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (35, 33, 3, 'I wish the app had more customization options.', '2025-11-27', 36);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (35, 1, 1, 'I wish the app had more customization options.', '2024-11-02', 1);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (22, 7, 1, 'The app is user-friendly and efficient.', '2024-04-09', 9);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (11, 36, 1, 'The app crashes frequently and needs improvement.', '2025-09-05', 11);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (15, 16, 5, 'I wish the app had more customization options.', '2024-02-26', 40);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (40, 9, 5, 'The app crashes frequently and needs improvement.', '2024-07-25', 17);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (5, 38, 1, 'I wish the app had more customization options.', '2024-07-14', 8);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (11, 27, 2, 'The app is user-friendly and efficient.', '2024-07-10', 28);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (7, 14, 4, 'I wish the app had more customization options.', '2023-12-09', 35);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (40, 9, 2, 'This app is amazing!', '2025-11-01', 11);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (13, 4, 2, 'I wish the app had more customization options.', '2025-02-04', 29);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (33, 39, 1, 'This app is amazing!', '2025-10-20', 16);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (28, 36, 3, 'I wish the app had more customization options.', '2025-11-29', 19);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (38, 29, 2, 'I love the new features added.', '2025-08-22', 11);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (22, 13, 3, 'The app crashes frequently and needs improvement.', '2025-08-01', 9);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (27, 24, 1, 'This app is amazing!', '2024-06-08', 32);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (6, 7, 3, 'This app is amazing!', '2024-08-27', 28);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (38, 15, 3, 'I love the new features added.', '2024-08-08', 22);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (17, 2, 2, 'This app is amazing!', '2025-06-16', 28);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (36, 12, 3, 'The app crashes frequently and needs improvement.', '2024-08-01', 33);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (25, 36, 3, 'I wish the app had more customization options.', '2025-09-23', 38);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (30, 39, 5, 'The app is user-friendly and efficient.', '2024-02-25', 19);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (28, 35, 5, 'I love the new features added.', '2024-03-15', 8);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (12, 28, 2, 'This app is amazing!', '2025-06-23', 17);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (17, 36, 1, 'This app is amazing!', '2024-07-12', 8);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (27, 38, 5, 'I love the new features added.', '2025-05-03', 24);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (9, 7, 3, 'The app is user-friendly and efficient.', '2024-03-09', 2);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (25, 40, 4, 'This app is amazing!', '2025-05-29', 17);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (39, 4, 5, 'The app is user-friendly and efficient.', '2025-05-07', 20);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (37, 4, 3, 'This app is amazing!', '2025-01-21', 6);
insert into UserFeedback (userID, featureID, rating, comments, timestamp, noteID) values (19, 10, 3, 'This app is amazing!', '2024-08-28', 33);

-- Insert Sample Data into DataLogs
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'data789', '2025-05-27', 25, 20);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'warning101', '2025-03-04', 9, 28);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'data789', '2025-01-04', 4, 32);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'log123', '2025-06-13', 40, 36);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'data789', '2024-07-20', 29, 30);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'error456', '2024-09-03', 9, 17);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'warning101', '2024-06-23', 15, 38);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'warning101', '2023-12-17', 28, 28);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'data789', '2023-12-20', 8, 27);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'warning101', '2024-02-02', 22, 21);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('info', 'error456', '2025-08-05', 13, 32);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'data789', '2024-01-18', 15, 5);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'log123', '2025-06-27', 1, 7);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('debug', 'error456', '2024-07-08', 31, 8);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('info', 'error456', '2025-04-13', 5, 15);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'data789', '2025-06-05', 32, 35);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'warning101', '2025-06-24', 17, 29);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'error456', '2024-06-25', 37, 13);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'warning101', '2024-04-21', 23, 22);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'warning101', '2025-08-09', 22, 18);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'log123', '2025-09-27', 15, 31);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'error456', '2025-07-14', 9, 15);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'log123', '2025-04-17', 26, 32);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('error', 'data789', '2024-11-09', 29, 28);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('info', 'error456', '2024-04-04', 38, 19);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('info', 'log123', '2025-03-09', 33, 30);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'data789', '2023-12-05', 1, 18);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'warning101', '2025-01-02', 8, 26);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'log123', '2024-09-18', 33, 10);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('info', 'warning101', '2024-09-05', 15, 28);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'data789', '2024-09-25', 32, 27);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('info', 'error456', '2025-11-02', 19, 31);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'data789', '2025-10-09', 12, 4);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'log123', '2025-08-21', 21, 40);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'warning101', '2024-11-25', 13, 23);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('critical', 'data789', '2023-12-25', 34, 35);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('debug', 'error456', '2024-06-14', 29, 30);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'warning101', '2024-08-12', 23, 15);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('warning', 'data789', '2024-04-02', 14, 35);
insert into DataLogs (type, details, timestamp, developerID, appID) values ('info', 'log123', '2024-04-11', 27, 27);

-- Insert Sample Data into Testing
insert into Testing (featureID, testType, runDate) values (22, 'Failed', '2024-08-16');
insert into Testing (featureID, testType, runDate) values (19, 'Failed', '2025-07-03');
insert into Testing (featureID, testType, runDate) values (3, 'Passed', '2023-12-06');
insert into Testing (featureID, testType, runDate) values (8, 'Failed', '2025-02-07');
insert into Testing (featureID, testType, runDate) values (3, 'Failed', '2025-05-23');
insert into Testing (featureID, testType, runDate) values (22, 'Passed', '2025-02-16');
insert into Testing (featureID, testType, runDate) values (12, 'Failed', '2025-06-23');
insert into Testing (featureID, testType, runDate) values (3, 'Passed', '2024-09-24');
insert into Testing (featureID, testType, runDate) values (30, 'Passed', '2024-02-23');
insert into Testing (featureID, testType, runDate) values (21, 'Failed', '2025-04-23');
insert into Testing (featureID, testType, runDate) values (39, 'Passed', '2025-10-31');
insert into Testing (featureID, testType, runDate) values (31, 'Passed', '2024-02-24');
insert into Testing (featureID, testType, runDate) values (38, 'Failed', '2025-11-19');
insert into Testing (featureID, testType, runDate) values (21, 'Passed', '2025-01-28');
insert into Testing (featureID, testType, runDate) values (22, 'Passed', '2025-02-25');
insert into Testing (featureID, testType, runDate) values (34, 'Failed', '2024-02-23');
insert into Testing (featureID, testType, runDate) values (28, 'Passed', '2024-08-07');
insert into Testing (featureID, testType, runDate) values (29, 'Passed', '2025-08-09');
insert into Testing (featureID, testType, runDate) values (10, 'Failed', '2025-01-28');
insert into Testing (featureID, testType, runDate) values (34, 'Failed', '2024-11-22');
insert into Testing (featureID, testType, runDate) values (12, 'Passed', '2025-08-01');
insert into Testing (featureID, testType, runDate) values (33, 'Failed', '2024-10-07');
insert into Testing (featureID, testType, runDate) values (21, 'Failed', '2024-06-25');
insert into Testing (featureID, testType, runDate) values (40, 'Passed', '2023-12-31');
insert into Testing (featureID, testType, runDate) values (31, 'Failed', '2024-12-07');
insert into Testing (featureID, testType, runDate) values (34, 'Passed', '2025-01-29');
insert into Testing (featureID, testType, runDate) values (40, 'Passed', '2025-01-18');
insert into Testing (featureID, testType, runDate) values (31, 'Failed', '2025-02-24');
insert into Testing (featureID, testType, runDate) values (25, 'Failed', '2024-08-19');
insert into Testing (featureID, testType, runDate) values (13, 'Passed', '2024-01-31');
insert into Testing (featureID, testType, runDate) values (1, 'Passed', '2024-10-21');
insert into Testing (featureID, testType, runDate) values (14, 'Failed', '2024-09-03');
insert into Testing (featureID, testType, runDate) values (3, 'Failed', '2025-08-27');
insert into Testing (featureID, testType, runDate) values (36, 'Passed', '2023-12-31');
insert into Testing (featureID, testType, runDate) values (6, 'Passed', '2025-04-17');
insert into Testing (featureID, testType, runDate) values (7, 'Failed', '2024-01-11');
insert into Testing (featureID, testType, runDate) values (25, 'Failed', '2025-04-17');
insert into Testing (featureID, testType, runDate) values (31, 'Passed', '2024-01-07');
insert into Testing (featureID, testType, runDate) values (25, 'Passed', '2024-01-16');
insert into Testing (featureID, testType, runDate) values (2, 'Passed', '2024-12-12');
