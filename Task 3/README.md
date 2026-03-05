# Task 3 — College Club Membership Database

> **ST4015CMD – Foundation of Computer Science**
> **Topic: Database Normalization, ER Diagram, and SQL Operations**

---

## 📑 Table of Contents

1. [Overview](#-overview)
2. [Files in This Folder](#-files-in-this-folder)
3. [How to Run the SQL](#-how-to-run-the-sql)
4. [The Problem — Unnormalized Table](#-the-problem--unnormalized-table)
5. [Data Anomalies Explained](#-data-anomalies-explained)
6. [Normalization Step by Step](#-normalization-step-by-step)
7. [Final Database Schema](#-final-database-schema)
8. [ER Diagram](#-er-diagram)
9. [SQL Operations — Task 4](#-sql-operations--task-4)
10. [SQL JOIN Operation — Task 5](#-sql-join-operation--task-5)
11. [Additional Queries](#-additional-queries)
12. [Reflection — Task 6](#-reflection--task-6)

---

## 📋 Overview

This task demonstrates **database normalization** through a real-world college club membership scenario. A single flat unnormalized table containing duplicate and inconsistent data is progressively restructured through **1NF**, **2NF**, and **3NF** — resulting in a clean, efficient, and fully reliable relational database with three separate tables.

---

## 📁 Files in This Folder

| File | Purpose |
|------|---------|
| `schema.sql` | `CREATE TABLE` statements only — the pure database structure with no data |
| `club_membership.sql` | Complete SQL file: schema + all INSERT, SELECT, JOIN, UPDATE, DELETE queries |
| `README.md` | This full documentation file |

**Which file should I use?**
- Use `schema.sql` if you want to understand the table structure before looking at data
- Use `club_membership.sql` to run the complete working database from scratch

---

## ▶️ How to Run the SQL

### Option A — SQLite (simplest, no account needed)
```bash
cd Task3-Club-Membership

# Run the full SQL file
sqlite3 club.db < club_membership.sql

# Or open SQLite interactively
sqlite3 club.db
.read club_membership.sql
.tables
SELECT * FROM Student;
```

### Option B — Online Editor (no installation required)
1. Go to [https://sqliteonline.com](https://sqliteonline.com)
2. Click **File → Open SQL File**
3. Select `club_membership.sql`
4. Click **Run**

### Option C — MySQL
```sql
CREATE DATABASE club_db;
USE club_db;
SOURCE club_membership.sql;
```

### Option D — PostgreSQL
```bash
psql -U postgres -c "CREATE DATABASE club_db;"
psql -U postgres -d club_db -f club_membership.sql
```

---

## ❌ The Problem — Unnormalized Table

The college originally stored all club data in one flat table:

| StudentID | StudentName | Email | ClubName | ClubRoom | ClubMentor | JoinDate |
|-----------|-------------|-------|----------|----------|------------|----------|
| 1 | Asha | asha@email.com | Music Club | R101 | Mr. Raman | 01/10/2024 |
| 2 | Bikash | bikash@email.com | Sports Club | R202 | Ms. Sita | 01/12/2024 |
| 1 | Asha | asha@email.com | Sports Club | R202 | Ms. Sita | 01/15/2024 |
| 3 | Nisha | nisha@email.com | Music Club | R101 | Mr. Raman | 01/20/2024 |
| 4 | Rohan | rohan@email.com | Drama Club | R303 | Mr. Kiran | 01/18/2024 |
| 5 | Suman | suman@email.com | Music Club | R101 | Mr. Raman | 01/22/2024 |
| 2 | Bikash | bikash@email.com | Drama Club | R303 | Mr. Kiran | 01/25/2024 |
| 6 | Pooja | pooja@email.com | Sports Club | R202 | Ms. Sita | 01/27/2024 |
| 3 | Nisha | nisha@email.com | Coding Club | Lab1 | Mr. Anil | 01/28/2024 |
| 7 | Aman | aman@email.com | Coding Club | Lab1 | Mr. Anil | 01/30/2024 |

### Three Core Problems

**Problem 1 — Redundant and Duplicate Data**
Asha's name and email appear twice — once per club she joins. Music Club's room (R101) and mentor (Mr. Raman) appear three times. This is wasted storage and creates inconsistency risk. If Asha changes her email, every row containing her data must be updated. Miss one row and the database becomes contradictory.

**Problem 2 — No True Primary Key**
`StudentID` repeats across multiple rows (Asha has StudentID 1 in two rows). It cannot serve as a primary key because it does not uniquely identify each row. There is no single column — or even simple combination — that cleanly identifies every row as a distinct, unique record.

**Problem 3 — Mixed Concerns in One Table**
Each row tries to record three entirely different facts simultaneously: who the student is, what the club is, and when the student joined. These are separate entities and should be stored separately. Mixing them causes the three types of anomalies described below.

### Why This Table is in 0NF (Unnormalized Form)
This table is in **0NF** because it has repeating groups (the same student data repeated per club) and multiple independent facts mixed into a single row. It does not satisfy the basic requirements of a structured relational database.

---

## ⚠️ Data Anomalies Explained

### Redundant Data vs Duplicate Data
- **Redundant data** means the same piece of information is stored in more than one place unnecessarily (e.g. Music Club's room number stored in 3 rows)
- **Duplicate data** means entire rows or records appear more than once (e.g. Asha's personal details appearing in rows 1 and 3)

Both waste storage and create opportunities for the database to become inconsistent.

### Insert Anomaly
An insert anomaly means you **cannot add a new record without also adding unrelated data**. In this table, you cannot create a record for a new Debate Club (room R404, mentor Ms. Priya) without also inventing a fake student row to go with it — the table structure forces every row to contain both student and club information simultaneously.

### Update Anomaly
An update anomaly means **changing one fact requires updating multiple rows**, creating a risk that some rows are missed. If Sports Club moves from room R202 to R205, rows 2, 3, and 8 all need updating. One missed row leaves the database in a contradictory state where Sports Club has two different room numbers at the same time.

### Deletion Anomaly
A deletion anomaly means **deleting one record accidentally destroys unrelated information**. Pooja is the only Sports Club entry that would remain if other members were removed. Deleting her row to remove her membership also permanently deletes all stored information about Sports Club — its room and mentor — from the entire database.

---

## ✅ Normalization Step by Step

### Step 1 — First Normal Form (1NF)

**Rule:** Every column must contain only atomic (single, indivisible) values. No repeating groups. A primary key must be defined.

**Applied:** All cells in the original table already contain single values (no comma-separated lists). To satisfy the primary key requirement, a **composite key** of `(StudentID, ClubName)` is used temporarily since neither column alone is unique. The table is now technically in 1NF.

**Remaining issue:** Student-specific attributes (`StudentName`, `Email`) depend only on `StudentID`, not on the full composite key. This partial dependency must be removed in 2NF.

---

### Step 2 — Second Normal Form (2NF)

**Rule:** Must be in 1NF, plus every non-key column must depend on the **entire** primary key, not just part of it.

**Applied:** The composite key is `(StudentID, ClubName)`:
- `StudentName` and `Email` depend only on `StudentID` → **partial dependency** → move to Student table
- `ClubRoom` and `ClubMentor` depend only on `ClubName` → **partial dependency** → move to Club table
- `JoinDate` depends on both `StudentID` and `ClubID` → stays in Membership table

Three tables are created:

**Student Table**

| StudentID (PK) | StudentName | Email |
|----------------|-------------|-------|
| 1 | Asha | asha@email.com |
| 2 | Bikash | bikash@email.com |
| 3 | Nisha | nisha@email.com |
| 4 | Rohan | rohan@email.com |
| 5 | Suman | suman@email.com |
| 6 | Pooja | pooja@email.com |
| 7 | Aman | aman@email.com |

**Club Table**

| ClubID (PK) | ClubName | ClubRoom | ClubMentor |
|-------------|----------|----------|------------|
| C1 | Music Club | R101 | Mr. Raman |
| C2 | Sports Club | R202 | Ms. Sita |
| C3 | Drama Club | R303 | Mr. Kiran |
| C4 | Coding Club | Lab1 | Mr. Anil |

**Membership Table**

| StudentID (FK) | ClubID (FK) | JoinDate |
|----------------|-------------|----------|
| 1 | C1 | 2024-01-10 |
| 2 | C2 | 2024-01-12 |
| 1 | C2 | 2024-01-15 |
| 3 | C1 | 2024-01-20 |
| 4 | C3 | 2024-01-18 |
| 5 | C1 | 2024-01-22 |
| 2 | C3 | 2024-01-25 |
| 6 | C2 | 2024-01-27 |
| 3 | C4 | 2024-01-28 |
| 7 | C4 | 2024-01-30 |

No partial dependencies remain.

---

### Step 3 — Third Normal Form (3NF)

**Rule:** Must be in 2NF, plus no **transitive dependencies** — no non-key column should depend on another non-key column.

**Applied:**
- Student table: `StudentName` and `Email` depend directly on `StudentID` only ✅
- Club table: `ClubName`, `ClubRoom`, `ClubMentor` depend directly on `ClubID` only ✅
- Membership table: `JoinDate` depends on the composite key `(StudentID, ClubID)` ✅

**Result:** All three tables are fully in **3NF**. The database is normalized, anomaly-free, and ready for production use.

---

## 🗄️ Final Database Schema

```sql
CREATE TABLE Student (
    StudentID   INTEGER      NOT NULL,
    StudentName VARCHAR(100) NOT NULL,
    Email       VARCHAR(150) NOT NULL,
    PRIMARY KEY (StudentID),
    UNIQUE (Email)
);

CREATE TABLE Club (
    ClubID      VARCHAR(10)  NOT NULL,
    ClubName    VARCHAR(100) NOT NULL,
    ClubRoom    VARCHAR(50)  NOT NULL,
    ClubMentor  VARCHAR(100) NOT NULL,
    PRIMARY KEY (ClubID)
);

CREATE TABLE Membership (
    StudentID   INTEGER     NOT NULL,
    ClubID      VARCHAR(10) NOT NULL,
    JoinDate    DATE        NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ClubID) REFERENCES Club(ClubID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```

---

## 🔷 ER Diagram

```
+--------------------+          +----------------------+          +--------------------+
|      STUDENT       |          |     MEMBERSHIP       |          |       CLUB         |
+--------------------+          +----------------------+          +--------------------+
| PK StudentID (INT) |──1────M──| FK StudentID (INT)   |──M────1──| PK ClubID (VAR)    |
|    StudentName     |          | FK ClubID    (VAR)   |          |    ClubName        |
|    Email           |          |    JoinDate  (DATE)  |          |    ClubRoom        |
+--------------------+          +----------------------+          |    ClubMentor      |
                                                                  +--------------------+
```

### Entities
- **Student** — represents a college student. Attributes: `StudentID` (PK), `StudentName`, `Email`
- **Club** — represents a college club. Attributes: `ClubID` (PK), `ClubName`, `ClubRoom`, `ClubMentor`
- **Membership** — associative entity recording which student joined which club and when. Attributes: `StudentID` (FK), `ClubID` (FK), `JoinDate`

### Relationships
- One **Student** can have many **Memberships** → one-to-many
- One **Club** can have many **Memberships** → one-to-many
- **Student** and **Club** have a **many-to-many** relationship, resolved through the Membership junction table

### Foreign Keys
- `Membership.StudentID` → references `Student.StudentID`
- `Membership.ClubID` → references `Club.ClubID`
- `ON DELETE CASCADE` — if a student or club is deleted, their membership records are automatically removed

---

## 🔹 SQL Operations — Task 4

### Insert a New Student
```sql
INSERT INTO Student (StudentID, StudentName, Email)
VALUES (8, 'Rina', 'rina@email.com');
```
This now works cleanly — no club data needed. Solves the **insert anomaly**.

### Insert a New Club
```sql
INSERT INTO Club (ClubID, ClubName, ClubRoom, ClubMentor)
VALUES ('C5', 'Debate Club', 'R404', 'Ms. Priya');
```
A new club can be added independently with no student required. This was impossible in the unnormalized table.

### Display All Students
```sql
SELECT * FROM Student;
```

### Display All Clubs
```sql
SELECT * FROM Club;
```

---

## 🔗 SQL JOIN Operation — Task 5

After normalization, data is split across three tables. A JOIN query re-combines it at query time.

```sql
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
```

### Expected Output

| StudentName | ClubName | JoinDate |
|-------------|----------|----------|
| Asha | Music Club | 2024-01-10 |
| Bikash | Sports Club | 2024-01-12 |
| Asha | Sports Club | 2024-01-15 |
| Rohan | Drama Club | 2024-01-18 |
| Nisha | Music Club | 2024-01-20 |
| Suman | Music Club | 2024-01-22 |
| Bikash | Drama Club | 2024-01-25 |
| Pooja | Sports Club | 2024-01-27 |
| Nisha | Coding Club | 2024-01-28 |
| Aman | Coding Club | 2024-01-30 |

### How It Works
- `Membership m` is the central table — it holds the foreign keys that link students to clubs
- `INNER JOIN Student s` matches each membership row to its student via `StudentID`
- `INNER JOIN Club c` matches each membership row to its club via `ClubID`
- `INNER JOIN` only returns rows where a match exists in all three tables
- `ORDER BY m.JoinDate` sorts results chronologically

---

## 🔍 Additional Queries

### Find all clubs a specific student joined
```sql
SELECT s.StudentName, c.ClubName, m.JoinDate
FROM Membership m
INNER JOIN Student s ON m.StudentID = s.StudentID
INNER JOIN Club c    ON m.ClubID    = c.ClubID
WHERE s.StudentName = 'Asha';
```

### Find all students in a specific club
```sql
SELECT s.StudentName, s.Email, m.JoinDate
FROM Membership m
INNER JOIN Student s ON m.StudentID = s.StudentID
INNER JOIN Club c    ON m.ClubID    = c.ClubID
WHERE c.ClubName = 'Music Club';
```

### Count members per club
```sql
SELECT c.ClubName, COUNT(m.StudentID) AS TotalMembers
FROM Club c
LEFT JOIN Membership m ON c.ClubID = m.ClubID
GROUP BY c.ClubName
ORDER BY TotalMembers DESC;
```

### Update a club room — solving the update anomaly
```sql
-- Only ONE row to update, not multiple — this is the power of normalization
UPDATE Club SET ClubRoom = 'R205' WHERE ClubID = 'C2';
```

### Remove a membership without losing club data — solving the deletion anomaly
```sql
-- Deleting Pooja's membership does NOT delete Sports Club
DELETE FROM Membership WHERE StudentID = 6 AND ClubID = 'C2';

-- Sports Club still exists
SELECT * FROM Club WHERE ClubID = 'C2';
```

---

## 💭 Reflection — Task 6

### How Normalization Reduces Data Repetition and Improves Accuracy

Before normalization, every student's name and email was stored once per club they joined. Every club's room and mentor was stored once per member. The same piece of information existed in multiple places with no guarantee they would stay consistent.

After normalization to 3NF, every piece of information exists in exactly one place. Asha's email is in one row in the Student table. Music Club's room is in one row in the Club table. If either needs updating, a single SQL `UPDATE` on a single row is sufficient — and the change is immediately and automatically reflected in every JOIN query that references it. There is no risk of partial updates leaving the database in a contradictory state.

The result is a database that is accurate, consistent, efficient in storage, and easy to maintain as data scales from 10 students to 10,000.

### Why JOIN Operations Are Necessary After Normalization

Normalization deliberately separates data into isolated tables to eliminate redundancy. But real queries need data from multiple tables simultaneously — "which students are in Music Club?" requires data from Student, Club, and Membership all at once. JOIN operations are the mechanism for re-linking this separated data at query time, using the shared foreign keys as connection points.

This is an intentional trade-off: queries require JOIN syntax, but the underlying data is dramatically more reliable. For a college managing hundreds of students and dozens of clubs, this trade-off is essential. Without normalization, a single table with thousands of duplicated rows would be slow, error-prone, and practically unmanageable.