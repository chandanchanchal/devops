-- Example for a single batch of 10 records
INSERT INTO employee_details (
    first_name, last_name, email, phone_number, hire_date, job_title,
    department_id, salary, bonus, is_active, address, city, state, zip_code
)
VALUES
('John', 'Doe', 'john.doe1@example.com', '1234567890', '2024-01-01', 'Software Engineer', 1, 50000, 500, TRUE, '123 Elm St', 'New York', 'NY', '10001'),
('Jane', 'Smith', 'jane.smith2@example.com', '1234567891', '2024-01-02', 'Data Scientist', 2, 60000, 700, TRUE, '124 Maple St', 'San Francisco', 'CA', '94101'),
-- Repeat for up to the batch size limit;
