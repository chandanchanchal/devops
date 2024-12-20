CREATE TABLE employee_details (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,        -- Primary key
    first_name VARCHAR(50) NOT NULL,                  -- First name, cannot be null
    last_name VARCHAR(50) NOT NULL,                   -- Last name, cannot be null
    email VARCHAR(100) UNIQUE NOT NULL,               -- Unique email address
    phone_number VARCHAR(15),                         -- Optional phone number
    hire_date DATE NOT NULL,                          -- Hiring date
    job_title VARCHAR(50) NOT NULL,                   -- Job title
    department_id INT,                                -- Foreign key (department reference)
    salary DECIMAL(10, 2),                            -- Salary with two decimal places
    bonus DECIMAL(10, 2) DEFAULT 0.00,                -- Bonus with default value
    is_active BOOLEAN DEFAULT TRUE,                   -- Active status with default value
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Auto-filled creation timestamp
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Auto-updated
    address VARCHAR(255),                             -- Address field
    city VARCHAR(50),                                 -- City field
    state VARCHAR(50),                                -- State field
    zip_code VARCHAR(10)                              -- ZIP Code
);
################################################################################################################################



-- Example for a single batch of 10 records
INSERT INTO employee_details (
    first_name, last_name, email, phone_number, hire_date, job_title,
    department_id, salary, bonus, is_active, address, city, state, zip_code
)
VALUES
('John', 'Doe', 'john.doe1@example.com', '1234567890', '2024-01-01', 'Software Engineer', 1, 50000, 500, TRUE, '123 Elm St', 'New York', 'NY', '10001'),
('Jane', 'Smith', 'jane.smith2@example.com', '1234567891', '2024-01-02', 'Data Scientist', 2, 60000, 700, TRUE, '124 Maple St', 'San Francisco', 'CA', '94101'),
-- Repeat for up to the batch size limit;


################################################################################################################################

import mysql.connector
from datetime import datetime, timedelta
import random

# Database connection
connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='your_password',
    database='your_database'
)
cursor = connection.cursor()

# Helper function to generate random data
def generate_record(record_id):
    first_name = f'First{record_id}'
    last_name = f'Last{record_id}'
    email = f'user{record_id}@example.com'
    phone_number = f'{random.randint(1000000000, 9999999999)}'
    hire_date = (datetime.now() - timedelta(days=random.randint(0, 3650))).strftime('%Y-%m-%d')
    job_title = random.choice(['Software Engineer', 'Data Scientist', 'Manager', 'HR'])
    department_id = random.randint(1, 10)
    salary = round(random.uniform(40000, 120000), 2)
    bonus = round(random.uniform(0, 10000), 2)
    is_active = random.choice([True, False])
    address = f'{random.randint(1, 999)} Random St'
    city = random.choice(['New York', 'San Francisco', 'Chicago', 'Austin'])
    state = random.choice(['NY', 'CA', 'IL', 'TX'])
    zip_code = f'{random.randint(10000, 99999)}'
    
    return (
        first_name, last_name, email, phone_number, hire_date, job_title,
        department_id, salary, bonus, is_active, address, city, state, zip_code
    )

# Insert records in batches
batch_size = 1000
total_records = 5000000

for batch_start in range(0, total_records, batch_size):
    batch_data = [generate_record(record_id) for record_id in range(batch_start, batch_start + batch_size)]
    insert_query = """
    INSERT INTO employee_details (
        first_name, last_name, email, phone_number, hire_date, job_title,
        department_id, salary, bonus, is_active, address, city, state, zip_code
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    cursor.executemany(insert_query, batch_data)
    connection.commit()
    print(f'Inserted batch {batch_start} to {batch_start + batch_size}')

cursor.close()
connection.close()

