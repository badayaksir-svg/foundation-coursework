# ST4015CMD – Foundation of Computer Science

> **Softwarica College of IT & E-Commerce | In collaboration with Coventry University**
> **Assignment Title: Investigation and Analysis of Computing Data for Data Management**
> **Student: Nischal Rana**

---

## 📑 Table of Contents

1. [About This Repository](#-about-this-repository)
2. [Repository Structure](#️-repository-structure)
3. [Task 1 — Encoding Formats & Secure Data Exchange](#-task-1--encoding-formats--secure-data-exchange)
4. [Task 2 — Classroom Seating Arrangement (P vs NP)](#-task-2--classroom-seating-arrangement-p-vs-np)
5. [Task 3 — College Club Membership Database](#️-task-3--college-club-membership-database)
6. [How to Run Each Task](#-how-to-run-each-task)
7. [Dependencies](#-dependencies)
8. [License](#-license)

---

## 📋 About This Repository

This repository contains all practical work, scripts, SQL files, and documentation for the **ST4015CMD Foundation of Computer Science** coursework assignment at Softwarica College of IT & E-Commerce.

The assignment covers three distinct areas of computer science:

| Task | Topic |
|------|-------|
| **Task 1** | Encoding Formats & Secure Data Exchange |
| **Task 2** | Classroom Seating Arrangement — P vs NP, Brute Force, Heuristics |
| **Task 3** | College Club Membership — Database Normalization & SQL |

---

## 🗂️ Repository Structure

```
FOUNDATION-COURSEWORK/
│
├── README.md                          ← You are here — main overview of all tasks
│
├── Task 1/
│   └── README.md                      ← Task 1 full documentation
│
├── Task 2/
│   └── README.md                      ← Task 2 full documentation
│
└── Task 3/
    ├── schema.sql                     ← CREATE TABLE definitions only (3NF structure)
    ├── club_membership.sql            ← Full SQL: schema + INSERT + SELECT + JOIN + UPDATE + DELETE
    └── README.md                      ← Task 3 full documentation
```

Each task folder has its own `README.md` with a detailed explanation of the approach, how to run the files, and the concepts demonstrated.

---

## 🔐 Task 1 — Encoding Formats & Secure Data Exchange

### Topic
Exploring the role of encoding formats in secure data exchange across web protocols and modern networks, including HTTPS, TLS, and SMTP.

### What Is Covered
This task investigates four encoding formats and their real-world applications in secure communication:

- **ASCII** — the foundation of all text-based protocols (HTTP, SMTP, HTML)
- **Base64** — used in HTTP Basic Authentication, SMTP email bodies, JWT tokens, and TLS certificates
- **Hex** — used in cryptographic hashes (SHA-256), TLS certificates, and MAC addresses
- **URL Encoding** — used in HTTP/HTTPS requests to safely transmit special characters and prevent injection attacks

It also covers:
- How encoding and TLS encryption work together in a complete data flow
- How attackers misuse encoding to obfuscate malicious payloads (Base64 obfuscation, double URL encoding)
- Mitigations and proposed improvements to encoding-based security strategies

📖 See `Task 1/README.md` for the full explanation of every section.

---

## 🪑 Task 2 — Classroom Seating Arrangement (P vs NP)

### Topic
Using a classroom seating problem to explore computational complexity — the difference between problems that are easy to solve (P) and problems that are hard to solve but easy to verify (NP).

### The Problem
A teacher must seat students in a single row so that:
1. Friends do not sit next to each other
2. Students from the same city do not sit next to each other

### What Is Covered

**P vs NP**
- Verifying a given seating plan is easy (P) — just check each adjacent pair against the rules
- Finding the correct arrangement is hard (NP) — every possible ordering must be considered
- This seating problem is NP-complete (similar to the graph colouring problem)

**Brute Force Approach**
- Generates every possible permutation of students using `itertools.permutations`
- Checks each arrangement against the friendship and city constraints
- Works for small groups but fails at scale — time complexity is O(n!) which grows factorially

**Heuristic Approach**
- Uses a greedy strategy — place the most constrained student first
- Dramatically faster than brute force
- May not always find the perfect solution but finds a good-enough solution in reasonable time

📖 See `Task 2/README.md` for the full explanation of P vs NP, time complexity analysis, and heuristic strategy.

---

## 🗄️ Task 3 — College Club Membership Database

### Topic
Demonstrating database normalization by transforming a single flat unnormalized table into a clean, efficient, anomaly-free relational database in Third Normal Form (3NF).

### The Original Problem
The college stored all club membership data in one table:

| StudentID | StudentName | Email | ClubName | ClubRoom | ClubMentor | JoinDate |
|-----------|-------------|-------|----------|----------|------------|----------|
| 1 | Asha | asha@email.com | Music Club | R101 | Mr. Raman | 01/10/2024 |
| 1 | Asha | asha@email.com | Sports Club | R202 | Ms. Sita | 01/15/2024 |
| 2 | Bikash | bikash@email.com | Sports Club | R202 | Ms. Sita | 01/12/2024 |
| ... | ... | ... | ... | ... | ... | ... |

This table had three critical problems: **duplicate data**, **no true primary key**, and **three types of data anomalies** — insert, update, and deletion anomalies.

### Normalized Result (3NF)
The data is split into three separate, clean tables:

```
Student  (StudentID PK, StudentName, Email)
    │
    │ one-to-many
    ▼
Membership  (StudentID FK, ClubID FK, JoinDate)   ← junction table
    │
    │ many-to-one
    ▼
Club  (ClubID PK, ClubName, ClubRoom, ClubMentor)
```

### What Is Covered
- Identifying data problems in the unnormalised table (Task 1)
- Defining redundant data, duplicate data, and all three anomalies with real examples
- Step-by-step normalization: 0NF → 1NF → 2NF → 3NF (Task 2)
- ER diagram showing entities, attributes, primary keys, foreign keys, and relationships (Task 3)
- Full SQL: CREATE TABLE, INSERT, SELECT, JOIN, UPDATE, DELETE (Tasks 4 & 5)
- Reflection on how normalization reduces repetition and why JOINs are necessary (Task 6)

### Key Files
| File | Description |
|------|-------------|
| `Task 3/schema.sql` | `CREATE TABLE` statements only — pure 3NF database structure with no data |
| `Task 3/club_membership.sql` | Complete SQL: unnormalised table + 3NF tables + all queries |

### Quick Run

**SQLite (simplest — pre-installed on most systems):**
```bash
cd "Task 3"
sqlite3 club.db < club_membership.sql
```

**Online editor (no installation needed):**
Go to [https://sqliteonline.com](https://sqliteonline.com) → File → Open SQL File → select `club_membership.sql` → Run

📖 See `Task 3/README.md` for the full normalization walkthrough, ER diagram, and all SQL queries explained in detail.

---

## ▶️ How to Run Each Task

### Prerequisites
- Python 3.8 or higher (Tasks 1 and 2)
- No external pip packages needed for any Python scripts — standard library only
- SQLite for Task 3 (pre-installed on most systems) or use the free online editor

### Full Setup

```bash
# Step 1 — Clone the repository
git clone https://github.com/your-username/FOUNDATION-COURSEWORK.git
cd FOUNDATION-COURSEWORK

# Step 2 — Run Task 1
cd "Task 1"
python encoding_demo.py

# Step 3 — Run Task 2
cd "../Task 2"
python brute_force.py
python heuristic.py

# Step 4 — Run Task 3
cd "../Task 3"
sqlite3 club.db < club_membership.sql
```

---

## 📦 Dependencies

| Task | Language | Libraries Used | Install Required? |
|------|----------|----------------|-------------------|
| Task 1 | Python 3.8+ | `base64`, `urllib.parse`, `hashlib`, `json` — all standard library | ❌ No |
| Task 2 | Python 3.8+ | `itertools`, `random`, `time` — all standard library | ❌ No |
| Task 3 | SQL | SQLite / MySQL / PostgreSQL | ✅ SQLite pre-installed on most systems |

---

## 📄 License

```
MIT License

Copyright (c) 2025 Nischal Rana

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
