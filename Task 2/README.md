# Task 2: Classroom Seating Arrangement Problem — P vs NP

> **Module: ST4015CMD – Foundation of Computer Science**
> **Assignment: Investigation and Analysis of Computing Data for Data Management**
> **Softwarica College of IT & E-Commerce | In collaboration with Coventry University**

---

## 📑 Table of Contents

1. [Overview of the Problem](#-overview-of-the-problem)
2. [The Two Rules](#-the-two-rules)
3. [What are P Problems?](#-what-are-p-problems)
4. [What are NP Problems?](#-what-are-np-problems)
5. [P vs NP — Key Difference](#-p-vs-np--key-difference)
6. [Applying P and NP to the Seating Problem](#-applying-p-and-np-to-the-seating-problem)
7. [Why Checking a Seating Plan is Easy](#-why-checking-a-seating-plan-is-easy)
8. [Why Finding a Correct Seating Plan is Difficult](#-why-finding-a-correct-seating-plan-is-difficult)
9. [Is This Problem P or NP?](#-is-this-problem-p-or-np)
10. [Visual Diagrams](#-visual-diagrams)
11. [References](#-references)

---

## 📋 Overview of the Problem

A teacher needs to arrange students in a single row of seats for an examination. The challenge is not simply placing students in any order — there are two rules that must be satisfied simultaneously. The teacher's job is to determine whether a valid arrangement even exists, and if it does, to find it.

This problem is a classic example used in computer science to illustrate the difference between two fundamental categories of computational problems: **P problems** and **NP problems**.

The scenario uses a small, concrete, relatable setting — a classroom — to represent a type of problem that appears in many real-world computational contexts, from scheduling systems and network routing to timetabling software and logistics planning.

---

## 📐 The Two Rules

Before exploring the theory, it is important to be clear about the exact constraints the teacher must satisfy:

**Rule 1 — Friends must not sit next to each other.**
If Student A and Student B are friends, they cannot be placed in adjacent seats. The concern is that they will talk and disrupt the examination.

**Rule 2 — Students from the same city must not sit next to each other.**
If Student A and Student C are both from the same city, they cannot be placed in adjacent seats either.

Both rules must be satisfied at the same time, for every pair of students, across the entire seating arrangement. The classroom has one row of seats, and every student must be seated exactly once.

---

## ✅ What are P Problems?

**P** stands for **Polynomial time**. A problem is classified as a P problem if there exists an algorithm that can **solve** it in polynomial time — meaning the time taken to find the answer grows at a manageable, predictable rate as the size of the input increases.

Polynomial time means the number of steps the algorithm takes is bounded by a polynomial expression such as n, n², or n³, where n is the size of the input (for example, the number of students).

### Simple Explanation

A P problem is one where a computer can **find the answer quickly and efficiently**, even as the problem gets larger. The time required does not explode uncontrollably as more data is added.

### Everyday Examples of P Problems

- **Sorting a list of names alphabetically** — efficient sorting algorithms like Merge Sort can sort n names in O(n log n) time. Doubling the number of names roughly doubles the time, which is very manageable.
- **Finding the shortest path between two locations on a map** — algorithms like Dijkstra's algorithm solve this efficiently even on large maps with thousands of roads.
- **Searching for a name in a sorted list** — binary search finds any item in a sorted list of n items in O(log n) steps.
- **Checking whether a number is prime** — there are efficient algorithms that can determine whether any given number is prime in polynomial time.

In all of these cases, as the input gets larger, the time taken grows predictably. These problems are considered **"easy"** from a computational perspective.

---

## ❓ What are NP Problems?

**NP** stands for **Nondeterministic Polynomial time**. A problem is classified as an NP problem if:

- A **proposed solution** (called a "certificate" or "witness") can be **verified** in polynomial time, but
- **Finding** a solution in the first place may require a very large amount of time — potentially exponential time — as the input grows

### Simple Explanation

An NP problem is one where if someone hands you an answer, you can **quickly check whether it is correct**. But actually **finding** a correct answer in the first place is very hard, especially as the problem gets bigger.

Think of it like a jigsaw puzzle. If someone hands you a completed jigsaw, you can quickly look at it and confirm whether it is correct (all the pieces fit, the picture is complete). But actually assembling the puzzle yourself from scratch takes much longer and gets dramatically harder as the number of pieces increases.

### Everyday Examples of NP Problems

- **Sudoku** — given a completed Sudoku grid, you can check in seconds whether every row, column, and box contains each digit exactly once. But solving a blank or partially filled Sudoku from scratch is much harder.
- **Planning the shortest route to visit multiple cities (Travelling Salesman Problem)** — given a proposed route, you can quickly calculate its total distance. But finding the shortest possible route among all cities is extremely hard as the number of cities grows.
- **Timetabling** — given a complete exam timetable, you can check whether any two exams that share students clash. But constructing a conflict-free timetable from scratch is very difficult.

---

## 🔀 P vs NP — Key Difference

| | P Problems | NP Problems |
|--|-----------|-------------|
| **Finding a solution** | Fast and efficient | Potentially very slow (exponential time) |
| **Checking a solution** | Fast and efficient | Fast and efficient |
| **Grows with input size** | Manageable (polynomial) | Can become unmanageable (exponential) |
| **Examples** | Sorting, searching, shortest path | Sudoku, Travelling Salesman, Seating constraints |

The most famous unsolved question in all of computer science is whether **P = NP** — that is, whether every problem whose solution can be quickly checked can also be quickly solved. Most computer scientists believe the answer is no (P ≠ NP), but this has never been formally proven.

---

## 🎓 Applying P and NP to the Seating Problem

### The Setup

Imagine the classroom has the following students:

| Student | Friends With | City |
|---------|-------------|------|
| Alice | Bob, Carol | Kathmandu |
| Bob | Alice | Kathmandu |
| Carol | Alice, David | Pokhara |
| David | Carol | Pokhara |
| Eve | — | Chitwan |

The teacher needs to seat all 5 students in a single row such that:
- No two friends are adjacent
- No two students from the same city are adjacent

---

## ✔️ Why Checking a Seating Plan is Easy

Suppose a student helper walks in and hands the teacher a proposed seating arrangement:

`[ Eve | Carol | Bob | Alice | David ]`

Can the teacher quickly verify whether this arrangement is valid? **Yes — absolutely.**

The teacher simply goes through the row seat by seat and checks each pair of adjacent students against the two rules:

**Step 1:** Check Eve and Carol
- Are they friends? No ✓
- Same city? No (Chitwan vs Pokhara) ✓

**Step 2:** Check Carol and Bob
- Are they friends? No ✓
- Same city? No (Pokhara vs Kathmandu) ✓

**Step 3:** Check Bob and Alice
- Are they friends? **Yes ✗** — Rule 1 violated!

The teacher immediately knows this arrangement is invalid. The entire check takes at most n-1 comparisons for a row of n students — this is O(n) time, which is very fast and grows only linearly with the number of students.

**This is why checking is a P-type operation.** No matter how many students there are, verification is always fast.

---

## 🔍 Why Finding a Correct Seating Plan is Difficult

Now suppose the teacher starts from scratch with no suggested arrangement. How do they find a valid one?

The only guaranteed method — without any clever shortcuts — is to try different arrangements and check each one. This is known as a **brute force** approach.

For n students, the number of possible seating arrangements is **n! (n factorial)**:

| Students (n) | Possible Arrangements (n!) |
|-------------|--------------------------|
| 3 | 6 |
| 5 | 120 |
| 10 | 3,628,800 |
| 15 | 1,307,674,368,000 |
| 20 | 2,432,902,008,176,640,000 |
| 30 | 265,252,859,812,191,058,636,308,480,000,000 |

As you can see, the number of arrangements grows **factorially** — far faster than any polynomial. This means:

- For 5 students, a computer could check all 120 arrangements almost instantly
- For 20 students, there are over 2 quintillion arrangements — even a powerful computer would struggle
- For 30 students, the number of arrangements exceeds the estimated number of atoms in the observable universe

This explosive growth is what makes finding the correct arrangement hard. There is no known algorithm that can always efficiently find a valid arrangement that satisfies both constraints without eventually resorting to checking a large number of possibilities.

---

## 🏷️ Is This Problem P or NP?

### Classification

The classroom seating arrangement problem — deciding whether a valid seating arrangement exists — is an **NP problem**. More specifically, it is closely related to a well-known NP-complete problem called the **Graph Colouring Problem** and the **Constraint Satisfaction Problem (CSP)**.

Here is why:

**It is in NP** because given any proposed arrangement, it can be verified in polynomial time (O(n) as shown above). Verification is fast.

**It is not known to be in P** because no efficient algorithm exists that can always find a valid arrangement quickly for any arbitrary set of students, friendships, and cities. As the number of students grows, the search space grows factorially.

**It resembles NP-complete problems** such as:
- **Graph Colouring** — where nodes (students) must be assigned colours (seats) such that no two connected nodes share the same colour (adjacent position constraint)
- **Boolean Satisfiability (SAT)** — deciding whether there is an assignment of values that satisfies a set of logical constraints simultaneously

### Summary Table

| Question | Answer | Reason |
|----------|--------|--------|
| Can a valid arrangement be checked quickly? | **Yes — P-type** | O(n) check through all adjacent pairs |
| Can a valid arrangement be found quickly? | **No — NP-type** | n! possible arrangements; no known efficient solver |
| Is verification faster than solving? | **Yes** | Checking one answer ≪ finding all answers |
| Overall classification | **NP** | Fast to verify, hard to solve in general |

---

## 📊 Visual Diagrams

### Diagram 1: Friendship and City Graph for the Example

This diagram represents students as nodes. A line (edge) between two students means they cannot sit next to each other (either because they are friends, or from the same city).

```
Alice ——— Bob          (Friends + Same city: Kathmandu)
  \
   Carol ——— David     (Friends + Same city: Pokhara)

Eve                    (No connections — can sit anywhere)
```

Finding a valid seating arrangement means placing all nodes in a line such that no two connected nodes are adjacent.

---

### Diagram 2: Verification vs Search — Time Comparison

```
Number of Students (n)
        |
        |  Verification Time (checking one arrangement)
        |  ───────────────────────────────────────────
        |  O(n) — grows slowly, linearly
        |
        |        *
        |      *
        |    *
        |  *
        |*_____________________________________ n
        |
        |  Search Time (finding a valid arrangement — brute force)
        |  ───────────────────────────────────────────────────────
        |  O(n!) — grows explosively
        |
        |                                    *
        |                              *
        |                       *
        |                *
        |        *
        |  *
        |*_____________________________________ n
```

The dramatic difference between the two curves illustrates exactly why this is an NP problem: verifying is easy (flat, linear growth), but finding is hard (explosive factorial growth).

---

### Diagram 3: P vs NP as Concentric Sets

```
┌─────────────────────────────────────────────┐
│                     NP                       │
│                                              │
│   ┌─────────────────────────────────────┐   │
│   │              NP-Complete            │   │
│   │   (Seating problem, SAT, Graph      │   │
│   │    Colouring, Travelling Salesman)  │   │
│   │                                     │   │
│   │  ┌──────────────────────────────┐  │   │
│   │  │              P               │  │   │
│   │  │  (Sorting, Searching,        │  │   │
│   │  │   Shortest Path, Primality)  │  │   │
│   │  └──────────────────────────────┘  │   │
│   └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘

Note: If P = NP (unproven), the P circle would expand
to fill the entire NP space.
```

---

## 📚 References

- Sipser, M. (2012) *Introduction to the Theory of Computation*. 3rd edn. Cengage Learning.
- Garey, M.R. and Johnson, D.S. (1979) *Computers and Intractability: A Guide to the Theory of NP-Completeness*. W.H. Freeman.
- Cormen, T.H. et al. (2022) *Introduction to Algorithms*. 4th edn. MIT Press.
- Cook, S.A. (1971) 'The complexity of theorem-proving procedures', *Proceedings of the Third Annual ACM Symposium on Theory of Computing*, pp. 151–158.
- Fortnow, L. (2009) 'The Status of the P Versus NP Problem', *Communications of the ACM*, 52(9), pp. 78–86.
- GeeksforGeeks (2024) *NP-Completeness*. Available at: https://www.geeksforgeeks.org/np-completeness-set-1/
