#PROCEDURE

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
		SELECT * FROM employees
        LIMIT 1000;
END$$

DELIMITER ;

CALL select_employees(); # or CALL employees.select_employees(); or CALL select_employees;

#Procedure to calculate Average Salary of all employees
DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN
		SELECT ROUND(AVG(salary),2) 
        FROM salaries;
END$$

DELIMITER ;

CALL avg_salary();

DROP PROCEDURE select_employees;

#Stored Procedure with an Input Parameter
DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
SELECT
	e.first_name, e.last_name, s.salary, s.from_date, s.to_date
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
END$$

DELIMITER ;

CALL emp_salary(11300);


DELIMITER $$
CREATE PROCEDURE emp_avg_salary(IN p_emp_no INTEGER)
BEGIN
SELECT
	e.first_name, e.last_name, AVG(s.salary)
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
END$$

DELIMITER ;

#Stored Procedure with an Output Parameter

DELIMITER $$
CREATE PROCEDURE emp_avg_salary_out(IN p_emp_no INTEGER, out p_avg_salary DECIMAL(10,2))
BEGIN
SELECT
	AVG(s.salary)
INTO p_avg_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
END$$

DELIMITER ;

#Create a procedure called "emp_info" that uses as parameters the first and the last name of an individual, 
#and returns their employee number.
DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(40), IN p_last_name VARCHAR(40), out p_emp_no_out INT(11))
BEGIN
SELECT
	e.emp_no
INTO p_emp_no_out FROM
	employees e
WHERE
	e.first_name = p_first_name AND e.last_name = p_last_name;
END$$

DELIMITER ;

# Variable

SET @v_avg_salary = 0;
CALL emp_avg_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;

SET @v_emp_no = 0;
CALL emp_info("Aruna", "Journel", @v_emp_no);
SELECT @v_emp_no;


#User Defined Functions
#READS SQL DATA is added at the end to avoid Error Code: 1418. Instead we could also disable
# the Binary Log creation while creating User defined functions with the following:
# SET @@global.log_bin_trust_function_creators := 1;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary(p_emp_no INTEGER) RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN

DECLARE v_avg_salary DECIMAL(10,2);

SELECT
	AVG(s.salary)
INTO v_avg_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;

RETURN v_avg_salary;
END$$

DELIMITER ;

SELECT f_emp_avg_salary(11300);


#Create a function called "emp_info" that takes for parameters the first and last name of 
#an employee, and returns the salary from the newest contract of that employee

DELIMITER $$
CREATE FUNCTION f_emp_info(p_first_name VARCHAR(40), p_last_name VARCHAR(40)) RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN

DECLARE v_latest_salary DECIMAL(10,2); 
DECLARE v_max_from_date DATE;

SELECT
	MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name AND e.last_name = p_last_name;

SELECT
	s.salary
INTO v_latest_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.first_name = p_first_name AND e.last_name = p_last_name
    AND s.from_date = v_max_from_date;

RETURN v_latest_salary;
END$$

DELIMITER ;

SELECT f_emp_info('Aruna', 'Journel');

#Using Function as one of the columns inside a SELECT statement

SET @v_emp_no = 11300;
SELECT emp_no, first_name, last_name, 
		f_emp_avg_salary(@v_emp_no) AS avg_salary
FROM 
	employees
WHERE
	emp_no = @v_emp_no;
    
    
#MySQL TRIGGER   
COMMIT;

# BEFORE INSERT
DELIMITER $$

CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = 0; 
	END IF; 
END $$

DELIMITER ;

# Let’s check the values of the “Salaries” table for employee 10001.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    
# Now, let’s insert a new entry for employee 10001, whose salary will be a negative number.
INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');

# Let’s run the same SELECT query to see whether the newly created record has a salary of 0 dollars per year.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    
# You can see that the “before_salaries_insert” trigger was activated automatically. It corrected the value of minus 92,891 
# we tried to insert. 

# Now, let’s look at a BEFORE UPDATE trigger. The code is similar to the one of the trigger we created above, with two 
# substantial differences.
# BEFORE UPDATE
DELIMITER $$

CREATE TRIGGER trig_upd_salary
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = OLD.salary; 
	END IF; 
END $$

DELIMITER ;

UPDATE salaries 
SET 
    salary = 98765
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';

SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
# Now, let’s run another UPDATE statement, with which we will try to modify the salary earned by 10001 with a negative value, minus 50,000.
UPDATE salaries 
SET 
    salary = - 50000
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
# Let’s run the same SELECT statement to check if the salary value was adjusted.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
# No, it wasn’t. Everything remained intact. So, we can conclude that only an update with a salary higher than zero dollars per year 
# would be implemented.

#System Functions
# Let’s introduce you to another interesting fact about MySQL. You already know there are pre-defined system variables, but system 
# functions exist too! 
# System functions can also be called built-in functions. 
# Often applied in practice, they provide data related to the moment of the execution of a certain query.

# For instance, SYSDATE() delivers the date and time of the moment at which you have invoked this function.
SELECT SYSDATE();

# Another frequently employed function, “Date Format”, assigns a specific format to a given date. For instance, the following query 
# could extract the current date, quoting the year, the month, and the day. 
SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') as today;

# As an exercise, try to understand the following query. Technically, it regards the creation of a more complex trigger. 
#It is of the size that professionals often have to deal with.

DELIMITER $$

CREATE TRIGGER trig_ins_dept_mng
AFTER INSERT ON dept_manager
FOR EACH ROW
BEGIN
	DECLARE v_curr_salary int;
    
    SELECT 
		MAX(salary)
	INTO v_curr_salary FROM
		salaries
	WHERE
		emp_no = NEW.emp_no;

	IF v_curr_salary IS NOT NULL THEN
		UPDATE salaries 
		SET 
			to_date = SYSDATE()
		WHERE
			emp_no = NEW.emp_no and to_date = NEW.to_date;

		INSERT INTO salaries 
			VALUES (NEW.emp_no, v_curr_salary + 20000, NEW.from_date, NEW.to_date);
    END IF;
END $$

DELIMITER ;

# After you are sure you have understood how this query works, please execute it and then run the following INSERT statement.  
INSERT INTO dept_manager VALUES ('111534', 'd009', date_format(sysdate(), '%y-%m-%d'), '9999-01-01');

# SELECT the record of employee number 111534 in the ‘dept_manager’ table, and then in the ‘salaries’ table to see how the output was affected. 
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no = 111534;
    
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = 111534;

# Conceptually, this was an ‘after’ trigger that automatically added $20,000 to the salary of the employee who was just promoted as a manager. 
# Moreover, it set the start date of her new contract to be the day on which you executed the insert statement.

# Finally, to restore the data in the database to the state from the beginning of this lecture, execute the following ROLLBACK statement. 
ROLLBACK;




#Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set this date to be the current date.
#Format the output appropriately (YY-MM-DD)

DELIMITER $$

CREATE TRIGGER trig_hire_date  

BEFORE INSERT ON employees

FOR EACH ROW  

BEGIN  

                IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN     

                                SET NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');     

                END IF;  

END $$  

DELIMITER ;  

   

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

SELECT  

    *  

FROM  

    employees

ORDER BY emp_no DESC;


#Indexes

SELECT * FROM employees
WHERE hire_date > '2000-01-01';

CREATE INDEX i_hire_date ON employees(hire_date);


#Composite Indexes

SELECT * FROM employees
WHERE first_name = 'Georgi' AND last_name = 'Facello';

CREATE INDEX i_composite ON employees(first_name, last_name);

#To list the indexes that are being used currently.
SHOW INDEX FROM employees FROM employees;


# CASE Statement
#Exmpl 1
SELECT emp_no, first_name, last_name,
	CASE
		WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
	END AS gender
FROM
	employees;
    
#Exmpl 2 (This way of using CASE statement doesn't work all the time)    
SELECT emp_no, first_name, last_name,
	CASE gender
		WHEN 'M' THEN 'Male'
        ELSE 'Female'
	END AS gender
FROM
	employees;
    
#Exmpl 3    
SELECT e.emp_no, e.first_name, e.last_name,
	CASE
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS is_manager
FROM
	employees e
		LEFT JOIN
	dept_manager dm ON dm.emp_no = e.emp_no
WHERE
	e.emp_no > 109990;
    
#Exmpl 4 (Without using CASE)
SELECT emp_no, first_name, last_name,
	IF(gender = 'M', 'Male', 'Female') AS gender
FROM
	employees;
    
#Exmpl 4
SELECT dm.emp_no, e.first_name, e.last_name,
	MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than 30k'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN
									'Salary was raised by more than 20K but less than 30k'
		ELSE 'Salary was raised by less than 20k'
	END AS salary_increase
FROM
	dept_manager dm
		JOIN
	employees e ON dm.emp_no = e.emp_no
		JOIN
	salaries s ON e.emp_no = s.emp_no
GROUP BY s.emp_no;


#Assignments

#Similar to the exercises done in the lecture, obtain a result set containing the employee number,
#first name, and last name of all employees with a number higher than 109990. Create a fourth
#column in the query, indicating whether this employee is also a manager, according to the data
#provided in the dept_manager table, or a regular employee.

SELECT

    e.emp_no,

    e.first_name,

    e.last_name,

    CASE

        WHEN dm.emp_no IS NOT NULL THEN 'Manager'

        ELSE 'Employee'

    END AS is_manager

FROM

    employees e

        LEFT JOIN

    dept_manager dm ON dm.emp_no = e.emp_no

WHERE

    e.emp_no > 109990;
    
    
#Extract a dataset containing the following information about the managers: employee number,
#first name, and last name. Add two columns at the end – one showing the difference between 
#the maximum and minimum salary of that employee, and another one saying whether this salary
#raise was higher than $30,000 or NOT.

SELECT

    dm.emp_no,  

    e.first_name,  

    e.last_name,  

    MAX(s.salary) - MIN(s.salary) AS salary_difference,  

    CASE  

        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more then $30,000'  

        ELSE 'Salary was NOT raised by more then $30,000'  

    END AS salary_raise  

FROM  

    dept_manager dm  

        JOIN  

    employees e ON e.emp_no = dm.emp_no  

        JOIN  

    salaries s ON s.emp_no = dm.emp_no  

GROUP BY s.emp_no;  

   

SELECT  

    dm.emp_no,  

    e.first_name,  

    e.last_name,  

    MAX(s.salary) - MIN(s.salary) AS salary_difference,  

    IF(MAX(s.salary) - MIN(s.salary) > 30000, 'Salary was raised by more then $30,000', 'Salary was NOT raised by more then $30,000') AS salary_increase  

FROM  

    dept_manager dm  

        JOIN  

    employees e ON e.emp_no = dm.emp_no  

        JOIN  

    salaries s ON s.emp_no = dm.emp_no  

GROUP BY s.emp_no;


#Extract the employee number, first name, and last name of the first 100 employees, and add a
#fourth column, called “current_employee” saying “Is still employed” if the employee is still
#working in the company, or “Not an employee anymore” if they aren’t.

SELECT

    e.emp_no,

    e.first_name,

    e.last_name,

    CASE

        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'

        ELSE 'Not an employee anymore'

    END AS current_employee

FROM

    employees e

        JOIN

    dept_emp de ON de.emp_no = e.emp_no

GROUP BY de.emp_no

LIMIT 100;