CREATE TABLE customers
(
	customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_id VARCHAR(255),
    number_of_complaints INT,
PRIMARY KEY(customer_id)
);

CREATE TABLE items
(
	item_code VARCHAR(255),
    item VARCHAR(255),
    unit_price NUMERIC(10,2),
    company_id VARCHAR(255),
PRIMARY KEY(item_code)
);

CREATE TABLE companies
(
	company_id VARCHAR(255),
    company_name VARCHAR(255),
    headquarters_phone_number INT(12),
PRIMARY KEY(company_id)
);

ALTER TABLE sales
ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

ALTER TABLE sales
DROP FOREIGN KEY Constraint_1;

-- DROP TABLE sales;
-- DROP TABLE customers;
-- DROP TABLE items;
-- DROP TABLE companies;
# Comments

ALTER TABLE customers
ADD UNIQUE KEY(email_id); 

ALTER TABLE customers
DROP INDEX email_id;

ALTER TABLE customers
ADD COLUMN gender ENUM('M','F') AFTER last_name;

INSERT INTO customers (first_name, last_name, gender, email_id, number_of_complaints)
VALUES ('John', 'Mackinley', 'M', 'john.mckinley@365datascience.com', 0);

SELECT *FROM customers;

ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0;

INSERT INTO customers (first_name, last_name, gender, email_id)
VALUES ('Peter', 'Figaro', 'M', 'peter.figaro@365datascience.com');

SELECT *FROM customers;

ALTER TABLE customers
ALTER COLUMN number_of_complaints DROP DEFAULT;

ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0;

ALTER TABLE companies
ADD UNIQUE KEY (headquarters_phone_number);

ALTER TABLE companies
CHANGE COLUMN company_name company_name VARCHAR(255) DEFAULT "X";

ALTER TABLE companies
ALTER COLUMN company_name DROP DEFAULT;

ALTER TABLE companies
CHANGE COLUMN headquarters_phone_number headquarters_phone_number VARCHAR(255) NOT NULL;
