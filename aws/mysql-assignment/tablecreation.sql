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
