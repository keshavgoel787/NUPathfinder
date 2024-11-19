DROP DATABASE IF EXISTS NUPathfinder;
CREATE DATABASE IF NOT EXISTS NUPathfinder;

USE NUPathfinder;

DROP TABLE IF EXISTS students;
CREATE TABLE IF NOT EXISTS students
(
    firstName varchar(50) NOT NULL,
    lastName varchar(50) NOT NULL,
    major varchar(50) NOT NULL,
    username varchar(50) NOT NULL,
    studentID INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (studentID)
);

DROP TABLE IF EXISTS Companies;
CREATE TABLE IF NOT EXISTS Companies(
    id int AUTO_INCREMENT not null primary key,
    CompanyName varchar(75),
    EmployeeNum int
);

DROP TABLE IF EXISTS Recruiters;
CREATE TABLE IF NOT EXISTS Recruiters(
    recId int AUTO_INCREMENT not null primary key,
    firstName varchar(50),
    lastName varchar(50),
    CompanyId int not null,
    FOREIGN KEY (CompanyId) references Companies(id)
);

DROP TABLE IF EXISTS jobs;
CREATE TABLE IF NOT EXISTS jobs
(
    position varchar(50) NOT NULL,
    description tinytext NOT NULL,
    startDate DATE NOT NULL,
    endDATE DATE NOT NULL,
    recruiterId int not null,
    jobID int AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (jobID),
    FOREIGN KEY (recruiterId) references Recruiters(recId)
);

DROP TABLE IF EXISTS skills;
CREATE TABLE IF NOT EXISTS skills
(
    name varchar(100) NOT NULL,
    description varchar(255) NOT NULL,
    category varchar(50),
    PRIMARY KEY (name)
);

DROP TABLE IF EXISTS experiences;
CREATE TABLE IF NOT EXISTS experiences
(
    title varchar(50) NOT NULL,
    studentID INT NOT NULL,
    review text,
    rating int CHECK (Rating >= 1 AND Rating <= 5) NOT NULL,
    jobID int NOT NULL,
    PRIMARY KEY (title, studentID),
    CONSTRAINT fk_01 FOREIGN KEY (studentID) REFERENCES students(studentID),
    CONSTRAINT fk_02 FOREIGN KEY (jobID) REFERENCES jobs(jobID)
);

DROP TABLE IF EXISTS studentSkills;
CREATE TABLE IF NOT EXISTS studentSkills
(
    studentID INT NOT NULL,
    name varchar(50) NOT NULL,
    proficiency varchar(50) NOT NULL,
    PRIMARY KEY (studentID, name),
    constraint fk_03 FOREIGN KEY (studentID) REFERENCES students(studentID),
    constraint fk_04 FOREIGN KEY (name) REFERENCES skills(name)
);

DROP TABLE IF EXISTS jobsSkills;
CREATE TABLE IF NOT EXISTS jobsSkills
(
    name varchar(50) NOT NULL,
    jobID int NOT NULL,
    proficiency varchar(50),
    PRIMARY KEY (name, jobID),
    constraint fk_05 FOREIGN KEY (name) REFERENCES skills(name),
    constraint fk_06 FOREIGN KEY (jobID) REFERENCES jobs(jobID)
);

DROP TABLE IF EXISTS application;
CREATE TABLE IF NOT EXISTS application
(
    applicationID int AUTO_INCREMENT NOT NULL,
    studentID INT NOT NULL,
    jobID int NOT NULL,
    dateOfApplication DATE DEFAULT (CURRENT_DATE),
    matchPercent int,
    status varchar(50) DEFAULT 'Submitted',
    PRIMARY KEY (applicationID),
    constraint fk_07 FOREIGN KEY (jobID) references jobs(jobID),
    constraint fk_08 FOREIGN KEY (studentID) references students(studentID)
);

CREATE TABLE IF NOT EXISTS BlackListed(
    RecId INT NOT NULL,
    StudentID INT NOT NULL,
    FOREIGN KEY (RecID) references Recruiters(recId),
    FOREIGN KEY (StudentID) references students(studentID)
);

INSERT INTO students (Username, FirstName, LastName, Major)
VALUES ('jdoe', 'John', 'Doe', 'Computer Science'),
       ('asmith', 'Alice', 'Smith', 'Mechanical Engineering');

INSERT INTO Companies (CompanyName, EmployeeNum)
VALUES ('Amazon', 10000),
       ('Apple', 20000);

INSERT INTO Recruiters (firstName, lastName, CompanyId)
VALUES ('John', 'Green', 1),
       ('Emily', 'Wang', 2);

INSERT INTO skills (name, description, category)
VALUES ('Java', 'Knowledge of Java language and related frameworks', 'Coding'),
       ('Python', 'Knowledge of Python language and related frameworks', 'Coding');

INSERT INTO jobs (position, startDate, endDATE, description, recruiterId)
VALUES ('Software Engineer', '2025-01-18','2025-07-01','Develop software applications and services', 1),
       ('Data Analyst', '2025-01-10','2025-06-29','Analyze data and generate insights for business decisions', 1);

INSERT INTO experiences (title, studentID, review, rating, jobID)
VALUES ('This company sucks', 1, 'Great learning experience with challenging projects', 5, 1),
       ('Best co-op ever', 2, 'Valuable experience with data-driven projects', 4, 2);

INSERT INTO studentSkills (studentID, name, proficiency)
VALUES
    (1, 'Python', 'Advanced'),
    (2, 'Java', 'Intermediate');

INSERT INTO jobsSkills (jobID, name)
VALUES (1, 'Python'),
       (2, 'Java');

INSERT INTO application (studentID, jobID)
VALUES (1, 1),
       (2, 2);

INSERT INTO BlackListed (RecId, StudentID)
VALUES (1, 2),
       (1, 1);
