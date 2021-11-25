SELECT 
    first_name, last_name
FROM
    employees;

SELECT 
    *
FROM
    employees;
    
SELECT dept_no FROM departments;
SELECT * FROM departments;

SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis';
    

# Operators AND,OR
SELECT
	*
FROM
	employees
WHERE
	first_name = 'Denis' OR first_name = 'Elvis';
    
SELECT * FROM employees
WHERE (first_name = 'Kellie' or first_name = 'Aruna') AND gender = 'F';


# Operators  (IN,LIKE,BETWEEN... AND...,IS NULL,etc.)
SELECT * FROM employees
WHERE first_name IN ('Cathie', 'Mark', 'Nathan');

SELECT * FROM employees
WHERE first_name NOT IN ('Cathie', 'Mark', 'Nathan');

SELECT * FROM employees
WHERE first_name = 'Kellie' or first_name = 'Nathan' or first_name = 'Mark';

SELECT * FROM employees
WHERE first_name LIKE ('Mar%');

SELECT * FROM employees
WHERE first_name LIKE ('Mar_');

SELECT * FROM employees
	WHERE first_name LIKE ('Mark%');
    
SELECT * FROM employees
	WHERE hire_date LIKE ('%2000%');
    
SELECT * FROM employees
	WHERE emp_no LIKE ('1000_');
    
SELECT * FROM employees
	WHERE first_name LIKE ('%Jack%');
    
SELECT * FROM employees
	WHERE first_name NOT IN ('%Jack%');
    
SELECT * FROM employees
	WHERE hire_date NOT BETWEEN '1990-01-01' AND '2000-01-01';
    
SELECT * FROM salaries
	WHERE salary BETWEEN 60000 AND 70000;
    
SELECT * FROM salaries
	WHERE emp_no NOT BETWEEN 10004 AND 10012;
    
SELECT * FROM departments
	WHERE dept_no BETWEEN "d003" AND "d006";
    
SELECT * FROM departments
	WHERE dept_no IS NOT NULL;


# Comparison Operators    
SELECT * FROM employees
	WHERE hire_date >= '2000-01-01' and gender = 'F';
    
SELECT * FROM salaries
	WHERE salary >= 150000;

# DISTINCT    
SELECT DISTINCT hire_date
	FROM employees;


# COUNT() 
 SELECT COUNT(emp_no) 
	FROM employees;
    
SELECT COUNT(DISTINCT last_name)
	FROM employees;

SELECT COUNT(salary)
	FROM salaries WHERE salary >= 100000;
    
SELECT COUNT(*)
	FROM salaries WHERE salary >= 100000;
 
SELECT COUNT(emp_no)
	FROM dept_manager;
    
SELECT COUNT(*)
	FROM dept_manager;


# ORDER BY
SELECT * FROM employees
	ORDER BY emp_no DESC;
    
SELECT * FROM employees
	ORDER BY first_name, last_name ASC;
    
SELECT * FROM employees
	ORDER BY hire_date DESC;
 
 
# GROUP BY 
SELECT 
    first_name, COUNT(first_name)
FROM
    employees
GROUP BY first_name;
        
SELECT 
    first_name, COUNT(first_name)
FROM
    employees
GROUP BY first_name
ORDER BY first_name DESC;


# Aliases(AS)
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
ORDER BY first_name DESC;

SELECT
	salary, COUNT(emp_no) AS Emp_count
FROM
	salaries
		WHERE salary >= 80000
GROUP BY salary
ORDER BY salary ASC;


# HAVING
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
HAVING COUNT(first_name) > 250
ORDER BY first_name;

SELECT 
    *, AVG(salary)
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) >= 120000
ORDER BY emp_no;

SELECT 
    first_name, COUNT(first_name)
FROM
    employees
WHERE
    hire_date >= '1999-01-01'
GROUP BY first_name
HAVING COUNT(first_name) <= 200
ORDER BY first_name ASC;

SELECT 
    emp_no, COUNT(emp_no) AS emp_count
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(emp_no) > 1
ORDER BY emp_no;

# LIMIT and INSERT... INTO... VALUES...
SELECT 
    *
FROM
    titles
LIMIT 10;

INSERT INTO employees
VALUES
(
    999903,
    '1977-09-14',
    'Johnathan',
    'Creek',
    'M',
    '1999-01-01'
);

INSERT INTO titles(emp_no,title,from_date)
values(999903, 'Senior Engineer', '1997-10-01'); 

SELECT 
    *
FROM
    titles
ORDER BY emp_no DESC;

INSERT into dept_emp
VALUES(999903, 'd005', '1997-10-01', '9999-01-01');

SELECT 
    *
FROM
    dept_emp
ORDER BY emp_no DESC
LIMIT 10;

# Another way to INSERT data into a table(via another table)
CREATE TABLE departments_dup (
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);

select * from departments_dup;

insert into departments_dup(
dept_no,
dept_name
)
select * from departments;

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

INSERT INTO departments(dept_no, dept_name)
VALUES('d010','Business Analysis'); 

SELECT * FROM departments;


# Update, COMMIT and ROLLBACK
SELECT * FROM employees
ORDER BY emp_no DESC;

SELECT * FROM employees
	WHERE emp_no = 999903;
    
UPDATE employees
SET
	first_name = "Jonathan",
    last_name = "Nolan",
    birth_date = '1980-12-31',
    gender = 'M'
WHERE
	emp_no = 999903;
    
SELECT * FROM employees
	WHERE emp_no = 999903;
 
SELECT * FROM departments;
 
COMMIT;

UPDATE departments_dup
SET
	dept_no = 'd011',
    dept_name = 'Quality Control';
    
SELECT * FROM departments_dup;

ROLLBACK;

SELECT * FROM departments_dup;
COMMIT;

UPDATE departments
SET
	dept_name = 'Data Analysis'
WHERE 
	dept_no = "d010";
    
SELECT * FROM departments;
COMMIT;

# Delete Statement
SELECT * FROM titles
WHERE emp_no = 999903;

DELETE FROM employees
WHERE emp_no = 999903;

SELECT * FROM employees
ORDER BY emp_no DESC;
ROLLBACK;

DELETE FROM departments
WHERE dept_no = "d010";

SELECT * FROM departments;


#Aggregare Functions

#COUNT()
SELECT COUNT(salary)
FROM salaries;

SELECT COUNT(DISTINCT salary)
FROM salaries;

SELECT COUNT(*)
FROM salaries;

SELECT COUNT(DISTINCT dept_no)
FROM dept_emp;


#SUM()
SELECT SUM(salary)
FROM salaries;

SELECT SUM(salary)
FROM salaries
WHERE from_date >= "1997-01-01";


# MAX() and MIN()
SELECT MAX(salary)
FROM salaries;

SELECT MIN(salary)
FROM salaries;


#AVG()
SELECT AVG(salary)
FROM salaries;

SELECT AVG(salary)
FROM salaries
WHERE from_date >= "1997-01-01";


#ROUND()
SELECT ROUND(AVG(salary))I
FROM salaries;

SELECT ROUND(AVG(salary),2)I
FROM salaries;

SELECT ROUND(AVG(salary),2)
FROM salaries
WHERE from_date >= "1997-01-01";


#COALESCE() - Preamble
SELECT * FROM departments_dup;

DELETE FROM departments_dup
WHERE dept_no = "d010";

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

INSERT INTO departments_dup(dept_no) 
VALUES ('d010'), ('d011');

SELECT * FROM departments_dup
ORDER BY dept_no ASC;

ALTER TABLE departments_dup
ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;

SELECT * FROM departments_dup
ORDER BY dept_no ASC;

COMMIT;

#IFNULL() & COALESCE()
SELECT 
    dept_no,
    IFNULL(dept_name,
            'Department name not provided') as dept_name
FROM
    departments_dup;

# With two arguments    
SELECT 
    dept_no,
    COALESCE(dept_name,
            'Department name not provided') as dept_name
FROM
    departments_dup;

#With three arguments
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_manager,dept_name,'N/A') AS dept_manager
FROM
    departments_dup
ORDER BY dept_no ASC;

#With single argument
SELECT 
    dept_no,
    dept_name,
    COALESCE('depatment manager name') AS fake_column
FROM
    departments_dup;
    
SELECT

    dept_no,

    dept_name,

    COALESCE(dept_no, dept_name) AS dept_info

FROM

    departments_dup

ORDER BY dept_no ASC;

SELECT

    IFNULL(dept_no, 'N/A') as dept_no,

    IFNULL(dept_name,

            'Department name not provided') AS dept_name,

    COALESCE(dept_no, dept_name) AS dept_info

FROM

    departments_dup

ORDER BY dept_no ASC;


#JOINs - Preamble
ALTER TABLE departments_dup
DROP COLUMN dept_manager;

SELECT * FROM departments_dup;

ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

INSERT INTO departments_dup(dept_name)
VALUES('Public Relations');

INSERT INTO departments_dup(dept_no)
VALUES('d010'),('d011');

DELETE FROM departments_dup
WHERE dept_no = "d002";

SELECT * FROM departments_dup;

DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup(
emp_no int(11) NOT NULL,
dept_no CHAR(4) NULL,
from_date DATE NOT NULL,
to_date DATE NULL);

insert into dept_manager_dup
select * from dept_manager;

INSERT INTO dept_manager_dup(emp_no,from_date)
VALUES(999904, '2017-01-01'),
	  (999905, '2017-01-01'),
      (999906, '2017-01-01'),
      (999907, '2017-01-01');
      
DELETE FROM dept_manager_dup
WHERE dept_no = 'd001';

SELECT * FROM dept_manager_dup;


#JOINs

#INNER JOIN
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
INNER JOIN 
departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

#Extract a list containing information about all 
#managers' employee number, first and last name, department number, and hire date.
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM employees e
INNER JOIN
dept_manager d ON e.emp_no = d.emp_no
ORDER BY e.emp_no;


#LEFT JOIN
SELECT * FROM departments_dup;

SELECT * FROM dept_manager_dup;

SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
LEFT JOIN 
departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.dept_no;

#Join the 'employees' and the 'dept_manager' tables to return a subset
#of all the employees whose last name is Markovitch. See if the output 
#contains a manager with that name
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date 
FROM employees e
LEFT JOIN
dept_manager d ON e.emp_no = d.emp_no
WHERE e.last_name = "Markovitch"
ORDER BY d.dept_no DESC;

#RIGHT JOIN
SELECT d.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
RIGHT JOIN 
departments_dup d ON m.dept_no = d.dept_no
ORDER BY dept_no;


#New(JOIN) and Old(WHERE) Join Syntax
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m
INNER JOIN 
departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

#The above result can be obtained just by using WHERE clause
SELECT m.dept_no, m.emp_no, d.dept_name
FROM dept_manager_dup m, departments_dup d
WHERE m.dept_no = d.dept_no
ORDER BY m.dept_no;


#Extract a list containing information about all 
#managers' employee number, first and last name,department number,
#and hire date. Use the old type of join syntax
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date 
FROM employees e, dept_manager_dup d
WHERE e.emp_no = d.emp_no
ORDER BY emp_no DESC;


#Using JOIN and WHERE in the same query
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 145000;

#Select the first and last name, the hire date,
#and the job title of all employees whose first name
#is "Margareta" and have the last name "Markovitch".
SELECT e.emp_no, e.first_name, e.last_name,e.hire_date,t.title
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE first_name = "Margareta" AND last_name = "Markovitch";


#CROSS JOINs
SELECT dm.*, d.*
FROM dept_manager dm
CROSS JOIN departments d
ORDER BY dm.emp_no, d.dept_no;

#Above result can be obtained by the following query too
SELECT dm.*,d.*
FROM dept_manager dm, departments d
ORDER BY dm.emp_no,d.dept_no;

#Retrieve details where the employee is part of departments but
#not to display where he/she is head of/working
SELECT dm.*,d.*
FROM departments d
CROSS JOIN dept_manager dm
WHERE d.dept_no <> dm.dept_no
ORDER BY dm.emp_no, d.dept_no;

#Using CROSS JOIN and JOIN to connect more than two tables
#To be handled with caution
SELECT e.*,d.*
FROM departments d
CROSS JOIN dept_manager dm
JOIN employees e ON dm.emp_no = e.emp_no
WHERE d.dept_no <> dm.dept_no
ORDER BY dm.emp_no, d.dept_no;

#Using Aggregate functions with JOINs

#Find the avg salary of employees by gender
SELECT e.gender, AVG(s.salary) as avg_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY gender;

#JOIN more than 2 tables in SQL

SELECT 
	e.first_name,e.last_name,e.hire_date,
	m.from_date,d.dept_name
FROM
	employees e
		JOIN
	dept_manager m ON e.emp_no = m.emp_no
		JOIN
	departments d ON m.dept_no = d.dept_no
;

#Select all managers' first and last name, hire date,
#job title, start date, and department name
SELECT
	e.first_name,e.last_name,e.hire_date,
    t.title,m.from_date,d.dept_name
FROM
	employees e
		JOIN
	titles t ON e.emp_no = t.emp_no
		JOIN
	dept_manager m ON t.emp_no = m.emp_no
		JOIN
	departments d ON m.dept_no = d.dept_no
WHERE t.title = "Manager"
ORDER BY e.emp_no;

#Find department names with Avg salary
SELECT d.dept_name, AVG(salary) AS avg_salary
FROM
	departments d
		JOIN
	dept_manager m ON d.dept_no = m.dept_no
		JOIN
	salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING avg_salary > 60000
ORDER BY avg_salary DESC
;

#Find out the number of male and female managers in the employees database
SELECT
    e.gender, COUNT(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;


#UNION vs. UNION ALL

DROP TABLE IF EXISTS employees_dup;
CREATE TABLE employees_dup(
	emp_no int(11),
    birth_date date,
    first_name varchar(14),
    last_name varchar(16),
    gender enum('M','F'),
    hire_date date
	);
    
INSERT INTO employees_dup
SELECT e.*
FROM employees e
LIMIT 20;

SELECT * from employees_dup;

INSERT INTO employees_dup VALUES
('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');

SELECT
	e.emp_no,e.first_name,e.last_name,
    NULL AS dept_no, NULL AS from_date
FROM
	employees_dup as e
WHERE e.emp_no = 10001
UNION ALL SELECT
	NULL AS emp_no,NULL as first_name, NULL AS last_name,
    m.dept_no, m.from_date
FROM
	dept_manager m;

