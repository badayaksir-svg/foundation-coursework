-- ============================================================
-- ST4015CMD – Foundation of Computer Science
-- College Club Membership Database
-- Unnormalised Table + Full 3NF Normalization
-- ============================================================


-- ============================================================
-- PART 1: ORIGINAL UNNORMALISED TABLE (0NF)
-- ============================================================

DROP TABLE IF EXISTS ClubMembership_Unnormalised;

CREATE TABLE ClubMembership_Unnormalised (
    StudentID   INTEGER,
    StudentName VARCHAR(100),
    Email       VARCHAR(150),
    ClubName    VARCHAR(100),
    ClubRoom    VARCHAR(50),
    ClubMentor  VARCHAR(100),
    JoinDate    DATE
);

-- Insert all original data (with duplicates — as given)
INSERT INTO ClubMembership_Unnormalised VALUES (1, 'Asha',   'asha@email.com',   'Music Club',  'R101', 'Mr. Raman', '2024-01-10');
INSERT INTO ClubMembership_Unnormalised VALUES (2, 'Bikash', 'bikash@email.com', 'Sports Club', 'R202', 'Ms. Sita',  '2024-01-12');
INSERT INTO ClubMembership_Unnormalised VALUES (1, 'Asha',   'asha@email.com',   'Sports Club', 'R202', 'Ms. Sita',  '2024-01-15');
INSERT INTO ClubMembership_Unnormalised VALUES (3, 'Nisha',  'nisha@email.com',  'Music Club',  'R101', 'Mr. Raman', '2024-01-20');
INSERT INTO ClubMembership_Unnormalised VALUES (4, 'Rohan',  'rohan@email.com',  'Drama Club',  'R303', 'Mr. Kiran', '2024-01-18');
INSERT INTO ClubMembership_Unnormalised VALUES (5, 'Suman',  'suman@email.com',  'Music Club',  'R101', 'Mr. Raman', '2024-01-22');
INSERT INTO ClubMembership_Unnormalised VALUES (2, 'Bikash', 'bikash@email.com', 'Drama Club',  'R303', 'Mr. Kiran', '2024-01-25');
INSERT INTO ClubMembership_Unnormalised VALUES (6, 'Pooja',  'pooja@email.com',  'Sports Club', 'R202', 'Ms. Sita',  '2024-01-27');
INSERT INTO ClubMembership_Unnormalised VALUES (3, 'Nisha',  'nisha@email.com',  'Coding Club', 'Lab1', 'Mr. Anil',  '2024-01-28');
INSERT INTO ClubMembership_Unnormalised VALUES (7, 'Aman',   'aman@email.com',   'Coding Club', 'Lab1', 'Mr. Anil',  '2024-01-30');

-- View unnormalised table
SELECT * FROM ClubMembership_Unnormalised;


-- ============================================================
-- PART 2: 3NF NORMALISED TABLES
-- ============================================================

DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Club;
DROP TABLE IF EXISTS Student;

-- -----------------------------------------------------------
-- Student Table
-- Each student stored exactly once.
-- StudentID = Primary Key
-- No club data here — avoids partial dependency
-- -----------------------------------------------------------
CREATE TABLE Student (
    StudentID   INTEGER      NOT NULL,
    StudentName VARCHAR(100) NOT NULL,
    Email       VARCHAR(150) NOT NULL,
    PRIMARY KEY (StudentID),
    UNIQUE (Email)
);

-- -----------------------------------------------------------
-- Club Table
-- Each club stored exactly once.
-- ClubID = Primary Key
-- ClubRoom and ClubMentor depend only on ClubID — fully 3NF
-- -----------------------------------------------------------
CREATE TABLE Club (
    ClubID      VARCHAR(10)  NOT NULL,
    ClubName    VARCHAR(100) NOT NULL,
    ClubRoom    VARCHAR(50)  NOT NULL,
    ClubMentor  VARCHAR(100) NOT NULL,
    PRIMARY KEY (ClubID)
);

-- -----------------------------------------------------------
-- Membership Table (Junction Table)
-- Resolves many-to-many between Student and Club.
-- Composite Primary Key: (StudentID, ClubID)
-- JoinDate depends on both keys — fully 3NF
-- -----------------------------------------------------------
CREATE TABLE Membership (
    StudentID   INTEGER     NOT NULL,
    ClubID      VARCHAR(10) NOT NULL,
    JoinDate    DATE        NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClubID)    REFERENCES Club(ClubID)
);


-- ============================================================
-- PART 3: INSERT DATA INTO 3NF TABLES
-- ============================================================

-- Students (each stored only ONCE — no duplicates)
INSERT INTO Student VALUES (1, 'Asha',   'asha@email.com');
INSERT INTO Student VALUES (2, 'Bikash', 'bikash@email.com');
INSERT INTO Student VALUES (3, 'Nisha',  'nisha@email.com');
INSERT INTO Student VALUES (4, 'Rohan',  'rohan@email.com');
INSERT INTO Student VALUES (5, 'Suman',  'suman@email.com');
INSERT INTO Student VALUES (6, 'Pooja',  'pooja@email.com');
INSERT INTO Student VALUES (7, 'Aman',   'aman@email.com');

-- Clubs (each stored only ONCE — no duplicates)
INSERT INTO Club VALUES ('C1', 'Music Club',  'R101', 'Mr. Raman');
INSERT INTO Club VALUES ('C2', 'Sports Club', 'R202', 'Ms. Sita');
INSERT INTO Club VALUES ('C3', 'Drama Club',  'R303', 'Mr. Kiran');
INSERT INTO Club VALUES ('C4', 'Coding Club', 'Lab1', 'Mr. Anil');

-- Memberships (who joined which club and when)
INSERT INTO Membership VALUES (1, 'C1', '2024-01-10'); -- Asha   → Music Club
INSERT INTO Membership VALUES (2, 'C2', '2024-01-12'); -- Bikash → Sports Club
INSERT INTO Membership VALUES (1, 'C2', '2024-01-15'); -- Asha   → Sports Club
INSERT INTO Membership VALUES (3, 'C1', '2024-01-20'); -- Nisha  → Music Club
INSERT INTO Membership VALUES (4, 'C3', '2024-01-18'); -- Rohan  → Drama Club
INSERT INTO Membership VALUES (5, 'C1', '2024-01-22'); -- Suman  → Music Club
INSERT INTO Membership VALUES (2, 'C3', '2024-01-25'); -- Bikash → Drama Club
INSERT INTO Membership VALUES (6, 'C2', '2024-01-27'); -- Pooja  → Sports Club
INSERT INTO Membership VALUES (3, 'C4', '2024-01-28'); -- Nisha  → Coding Club
INSERT INTO Membership VALUES (7, 'C4', '2024-01-30'); -- Aman   → Coding Club


-- ============================================================
-- PART 4: BASIC SELECT QUERIES (Task 4)
-- ============================================================

-- Display all students
SELECT * FROM Student;

-- Display all clubs
SELECT * FROM Club;

-- Display all memberships
SELECT * FROM Membership;

-- Insert a new student
INSERT INTO Student VALUES (8, 'Rina', 'rina@email.com');

-- Insert a new club (was impossible in the unnormalised table without a fake student row)
INSERT INTO Club VALUES ('C5', 'Debate Club', 'R404', 'Ms. Priya');


-- ============================================================
-- PART 5: JOIN QUERY (Task 5)
-- Display StudentName, ClubName, JoinDate across all 3 tables
-- ============================================================

SELECT
    s.StudentName,
    c.ClubName,
    m.JoinDate
FROM
    Membership m
INNER JOIN Student s ON m.StudentID = s.StudentID
INNER JOIN Club c    ON m.ClubID    = c.ClubID
ORDER BY
    m.JoinDate;


-- ============================================================
-- PART 6: DEMONSTRATING ANOMALY FIXES
-- ============================================================

-- UPDATE ANOMALY FIX:
-- Change Sports Club room from R202 to R205.
-- In the unnormalised table this needed 3 row updates.
-- Here, only ONE row needs updating.
UPDATE Club
SET ClubRoom = 'R205'
WHERE ClubID = 'C2';

-- DELETION ANOMALY FIX:
-- Remove Pooja from Sports Club.
-- In the unnormalised table this deleted all Sports Club info.
-- Here, Sports Club still exists in the Club table safely.
DELETE FROM Membership
WHERE StudentID = 6 AND ClubID = 'C2';

-- Confirm Sports Club still exists after deletion
SELECT * FROM Club WHERE ClubID = 'C2';

-- ============================================================
-- END
-- ============================================================
