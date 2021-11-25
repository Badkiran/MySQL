#Sub-queries
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.emp_no IN (SELECT dm.emp_no
				FROM
					dept_manager dm);
                    
#Extract the information about all department managers
#who were hired between the 1st of January 1990 and the 1st of January 1995
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.emp_no IN (SELECT dm.emp_no, dm.from_date
				FROM
					dept_manager dm
						WHERE from_date >= "1990-01-01" AND from_date <= "1995-01-01");
					
                    
#EXISTS
SELECT e.first_name, e.last_name
FROM employees e
WHERE
	EXISTS (SELECT *
		FROM
			dept_manager dm
		WHERE
			dm.emp_no = e.emp_no);
            
SELECT e.first_name, e.last_name
FROM employees e
WHERE
	EXISTS (SELECT *
		FROM
			dept_manager dm
		WHERE
			dm.emp_no = e.emp_no)
ORDER BY emp_no;

#Select the entire information for all employees whose job title is "Assistant Engineer"
SELECT e.first_name, e.last_name
FROM employees e
WHERE
	EXISTS (SELECT *
		FROM
			titles t
		WHERE
			t.emp_no = e.emp_no AND t.title = "Assistant Engineer")
ORDER BY emp_no;


#Assign employee number 110022 as a manager to all employees from 10001 to 10020 and
#employee number 110039 as a manager to all employees from 10021 to 10040
#(Hint: Use employee and dept_emp tables)

SELECT 
	A.*
FROM
	(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code,
		(SELECT emp_no
		FROM dept_manager
		WHERE emp_no = 110022) AS manager_ID
	FROM 
		employees e
			JOIN
		dept_emp de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no <= 10020
	GROUP BY e.emp_no
	ORDER BY e.emp_no) AS A
UNION SELECT 
	B.*
FROM
	(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code,
		(SELECT emp_no
		FROM dept_manager
		WHERE emp_no = 110039) AS manager_ID
	FROM 
		employees e
			JOIN
		dept_emp de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no > 10020 and e.emp_no <= 10040
	GROUP BY e.emp_no
	ORDER BY e.emp_no) AS B;
    
    
#Fill emp_manager with data about employees, the number of the department they are working in, and their managers.
#Your query skeleton must be:
#Insert INTO emp_manager SELECT
#U.*
#FROM
#                 (A)
#UNION (B) UNION (C) UNION (D) AS U;
#A and B should be the same subsets used in the last lecture (SQL Subqueries Nested in SELECT and FROM). 
#In other words, assign employee number 110022 as a manager to all employees from 10001 to 10020 (this must be subset A), 
#and employee number 110039 as a manager to all employees from 10021 to 10040 (this must be subset B).

#Use the structure of subset A to create subset C, where you must assign employee number 110039 as a manager to employee 110022.
#Following the same logic, create subset D. Here you must do the opposite - assign employee 110022 as a manager to employee 110039.
#Your output must contain 42 rows.

DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager(
	emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

INSERT INTO emp_manager SELECT
U.*
	FROM
		  (SELECT A.*
		  FROM
			(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code,
				(SELECT emp_no
				FROM dept_manager
				WHERE emp_no = 110022) AS manager_ID
			FROM 
				employees e
					JOIN
				dept_emp de ON e.emp_no = de.emp_no
			WHERE
				e.emp_no <= 10020
			GROUP BY e.emp_no
			ORDER BY e.emp_no) AS A
		UNION SELECT 
			B.*
			FROM
				(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code,
					(SELECT emp_no
					FROM dept_manager
					WHERE emp_no = 110039) AS manager_ID
				FROM 
					employees e
						JOIN
					dept_emp de ON e.emp_no = de.emp_no
				WHERE
					e.emp_no > 10020 and e.emp_no <= 10040
				GROUP BY e.emp_no
				ORDER BY e.emp_no) AS B
		UNION SELECT 
			C.*
			FROM
				(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code,
					(SELECT emp_no
					FROM dept_manager
					WHERE emp_no = 110039) AS manager_ID
				FROM 
					employees e
						JOIN
					dept_emp de ON e.emp_no = de.emp_no
				WHERE
					e.emp_no = 110022
				GROUP BY e.emp_no
				ORDER BY e.emp_no) AS C
		UNION SELECT
			D.*
			FROM
				(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code,
					(SELECT emp_no
					FROM dept_manager
					WHERE emp_no = 110022) AS manager_ID
				FROM 
					employees e
						JOIN
					dept_emp de ON e.emp_no = de.emp_no
				WHERE
					e.emp_no = 110039
				GROUP BY e.emp_no
				ORDER BY e.emp_no) AS D) as U;
		
SELECT * FROM emp_manager;

#SELF-JOIN
SELECT DISTINCT
	e1.*
FROM
		emp_manager e1
			JOIN
		emp_manager e2 ON e1.emp_no = e2.manager_no;
        
#OR

SELECT
	e1.*
FROM
		emp_manager e1
			JOIN
		emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE
	e2.emp_no IN (SELECT
			manager_no
		FROM
			emp_manager);
            

#VIEWs

SELECT * FROM dept_emp;

SELECT emp_no, from_date, to_date, COUNT(emp_no) AS Num
FROM dept_emp
GROUP BY emp_no
HAVING Num >1;

CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
SELECT
	emp_no, MAX(from_date) as from_date, MAX(to_date) AS to_date
FROM
	dept_emp
GROUP BY emp_no;


CREATE OR REPLACE VIEW v_avg_salary_all_managers AS
SELECT
	ROUND(AVG(s.salary),2) AS avg_salary
    FROM
		dept_manager d
			JOIN
		salaries s ON d.emp_no = s.emp_no;
        
