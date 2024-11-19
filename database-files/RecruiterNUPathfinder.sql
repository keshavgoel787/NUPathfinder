CREATE TABLE IF NOT EXISTS Companies(
    id int AUTO_INCREMENT not null primary key,
    CompanyName varchar(75),
    EmployeeNum int
);

CREATE TABLE IF NOT EXISTS Recruiters(
    recId int AUTO_INCREMENT not null primary key,
    firstName varchar(50),
    lastName varchar(50),
    CompanyId int not null,

    FOREIGN KEY (CompanyId) references Companies(id)
);

CREATE TABLE IF NOT EXISTS Jobs(
    position varchar(75),
    description varchar(255),
    recruiterId int not null,

    FOREIGN KEY (recruiterId) references Recruiters(recId),
   JobID int AUTO_INCREMENT not null primary key
);

CREATE TABLE IF NOT EXISTS skills(
    SkillID int AUTO_INCREMENT not null primary key,
    Name varchar(50),
    Description varchar(255)
);

CREATE TABLE IF NOT EXISTS skills_Jobs(
    JobID int not null,
    SkillID int not null,
    proficiency int,
    FOREIGN KEY (JobID) references Jobs(JobID),
    FOREIGN KEY (SkillId) references skills(SkillID),
    PRIMARY KEY (JobID,SkillID)
);

CREATE TABLE IF NOT EXISTS Best_Matches(
    JobId INT NOT NULL,
    StudentID INT NOT NULL,
    matchPercent int,
    FOREIGN KEY (JobID) references Jobs(JobID)
 /*studentId should also be a foreign key*/
);

CREATE TABLE IF NOT EXISTS BlackListed(
    RecId INT NOT NULL,
    StudentID INT NOT NULL,
    FOREIGN KEY (RecID) references Recruiters(recId)
 /*studentId should also be a foreign key*/
);


/*user stories SQL CRUD queries for persona 2:
 */

-- 2.1
SELECT * from Best_Matches where JobId = 1;

-- 2.2 (won't work until I have skills_studnets database
SELECT * from skills NATURAL JOIN skills_Students where studentId = 1;

-- 2.3
INSERT INTO BlackListed VALUES(1, 1);

-- 2.4
SELECT skills_Students.proficiency from skills_Students WHERE StudentId = 1;

-- 2.5
-- remove job offer
DELETE FROM Jobs where JobID = 1;
INSERT into Jobs values ("Head of Computer Science", "Manage comp sci at northeastern" );

-- 2.6
UPDATE Jobs SET Position = "new position", description = "New Descritpion"
WHERE JobID = 2;