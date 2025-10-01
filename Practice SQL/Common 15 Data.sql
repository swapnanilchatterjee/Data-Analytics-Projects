-- 1. CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    address TEXT,
    registration_date DATE
);

-- 2. DEPARTMENTS TABLE
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- 3. EMPLOYEES TABLE
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- 4. SALARY_HISTORY TABLE
CREATE TABLE salary_history (
    salary_id SERIAL PRIMARY KEY,
    employee_id INT,
    salary DECIMAL(10,2),
    effective_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 5. STORES TABLE
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

-- 6. PRODUCTS TABLE
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

-- 7. ORDERS TABLE
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2),
    store_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- 8. ORDER_ITEMS TABLE
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 9. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 10. SALES TABLE
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    employee_id INT,
    product_id INT,
    sale_date DATE,
    sale_amount DECIMAL(10,2),
    quantity_sold INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 11. DAILY_SALES TABLE
CREATE TABLE daily_sales (
    sale_date DATE PRIMARY KEY,
    total_amount DECIMAL(10,2)
);

-- 12. BOOKS TABLE
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    author VARCHAR(100),
    isbn VARCHAR(20),
    publication_year INT
);

-- 13. BOOK_BORROWINGS TABLE
CREATE TABLE book_borrowings (
    borrowing_id SERIAL PRIMARY KEY,
    book_id INT,
    borrower_name VARCHAR(100),
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- 14. STUDENTS TABLE
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100),
    score INT
);

-- =============================================
-- SAMPLE DATA INSERTION
-- =============================================

-- Insert Departments
INSERT INTO departments (department_id, department_name, location) VALUES
(101, 'Sales', 'New York'),
(102, 'Marketing', 'California'),
(103, 'IT', 'Texas'),
(104, 'HR', 'Florida');

-- Insert Employees
INSERT INTO employees (employee_name, department_id, salary, hire_date, manager_id) VALUES
('John Smith', 101, 75000, '2022-01-15', NULL),
('Jane Doe', 101, 65000, '2022-03-20', 1),
('Mike Johnson', 101, 80000, '2021-11-10', 1),
('Sarah Wilson', 102, 70000, '2022-02-28', NULL),
('David Brown', 102, 60000, '2022-04-15', 4),
('Lisa Garcia', 103, 85000, '2021-12-01', NULL),
('Tom Anderson', 103, 72000, '2022-01-30', 6),
('Emily Davis', 104, 68000, '2022-03-05', NULL),
('Chris Miller', 101, 78000, '2021-10-20', 1);

-- Insert Salary History
INSERT INTO salary_history (employee_id, salary, effective_date) VALUES
(1, 70000, '2022-01-15'),
(1, 75000, '2023-01-15'),
(2, 60000, '2022-03-20'),
(2, 65000, '2023-03-20'),
(3, 75000, '2021-11-10'),
(3, 80000, '2022-11-10'),
(4, 65000, '2022-02-28'),
(4, 70000, '2023-02-28'),
(5, 55000, '2022-04-15'),
(5, 60000, '2023-04-15'),
(6, 80000, '2021-12-01'),
(6, 85000, '2022-12-01'),
(7, 68000, '2022-01-30'),
(7, 72000, '2023-01-30'),
(8, 63000, '2022-03-05'),
(8, 68000, '2023-03-05'),
(9, 73000, '2021-10-20'),
(9, 78000, '2022-10-20');

-- Insert Stores
INSERT INTO stores (store_name, city, state) VALUES
('Downtown Store', 'Los Angeles', 'CA'),
('Mall Store', 'Los Angeles', 'CA'),
('Uptown Store', 'New York', 'NY'),
('Suburban Store', 'Chicago', 'IL');

-- Insert Customers
INSERT INTO customers (customer_name, email, phone, address, registration_date) VALUES
('Alice Johnson', 'alice@email.com', '555-0101', '123 Main St', '2022-12-15'),
('Bob Smith', 'bob@email.com', '555-0102', '456 Oak Ave', '2023-01-20'),
('Carol Brown', 'carol@email.com', '555-0103', '789 Pine Rd', '2023-02-10'),
('David Wilson', 'david@email.com', '555-0104', '321 Elm St', '2023-01-05'),
('Eva Garcia', 'eva@email.com', '555-0105', '654 Maple Dr', '2022-11-30');

-- Insert Products
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 999.99, 50),
('Smartphone', 'Electronics', 699.99, 100),
('Headphones', 'Electronics', 199.99, 75),
('Desk Chair', 'Furniture', 299.99, 30),
('Coffee Maker', 'Appliances', 149.99, 40),
('Book Shelf', 'Furniture', 199.99, 25),
('Tablet', 'Electronics', 399.99, 60);

-- Insert Orders
INSERT INTO orders (customer_id, order_date, order_amount, store_id) VALUES
(1, '2022-12-20', 1199.98, 1),
(2, '2023-01-25', 899.98, 2),
(2, '2023-02-15', 1499.97, 1),
(3, '2023-02-20', 599.98, 3),
(3, '2023-03-10', 349.98, 2),
(4, '2023-01-10', 1299.98, 1),
(4, '2023-04-15', 799.98, 4),
(5, '2022-12-05', 299.99, 2),
(1, '2023-05-20', 1899.96, 1),
(2, '2023-06-10', 499.98, 3);

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99), (1, 3, 1, 199.99),
(2, 2, 1, 699.99), (2, 3, 1, 199.99),
(3, 1, 1, 999.99), (3, 5, 1, 149.99), (3, 4, 1, 299.99),
(4, 2, 1, 699.99),
(5, 5, 1, 149.99), (5, 3, 1, 199.99),
(6, 1, 1, 999.99), (6, 4, 1, 299.99),
(7, 2, 1, 699.99), (7, 3, 1, 199.99),
(8, 4, 1, 299.99),
(9, 1, 2, 999.99),
(10, 7, 1, 399.99), (10, 3, 1, 199.99);

-- Insert Payments
INSERT INTO payments (order_id, payment_date, payment_amount, payment_method) VALUES
(1, '2022-12-20', 1199.98, 'Credit Card'),
(2, '2023-01-25', 899.98, 'Debit Card'),
(3, '2023-02-15', 1499.97, 'Credit Card'),
(4, '2023-02-20', 599.98, 'Cash'),
(5, '2023-03-10', 349.98, 'Credit Card'),
(6, '2023-01-10', 1299.98, 'Credit Card'),
(7, '2023-04-15', 799.98, 'Debit Card'),
(8, '2022-12-05', 299.99, 'Cash'),
(9, '2023-05-20', 1899.96, 'Credit Card'),
(10, '2023-06-10', 499.98, 'Debit Card');

-- Insert Sales Data
INSERT INTO sales (employee_id, product_id, sale_date, sale_amount, quantity_sold) VALUES
(1, 1, '2023-01-15', 999.99, 1),
(1, 2, '2023-01-20', 1399.98, 2),
(1, 3, '2023-02-10', 599.97, 3),
(2, 1, '2023-01-25', 1999.98, 2),
(2, 4, '2023-02-15', 899.97, 3),
(3, 2, '2023-01-30', 699.99, 1),
(3, 1, '2023-02-20', 2999.97, 3),
(1, 5, '2023-03-05', 749.95, 5),
(2, 1, '2023-03-15', 3999.96, 4),
(3, 3, '2023-03-25', 999.95, 5),
(1, 1, '2023-04-10', 1999.98, 2),
(2, 2, '2023-04-20', 1399.98, 2);

-- Insert Daily Sales
INSERT INTO daily_sales (sale_date, total_amount) VALUES
('2023-01-15', 2500.00),
('2023-01-16', 3200.00),
('2023-01-17', 1800.00),
('2023-01-18', 4100.00),
('2023-01-19', 2900.00),
('2023-01-20', 3500.00),
('2023-01-21', 2200.00),
('2023-01-22', 3800.00),
('2023-01-23', 4500.00),
('2023-01-24', 2700.00),
('2023-01-25', 3900.00),
('2023-01-26', 2600.00),
('2023-01-27', 4200.00),
('2023-01-28', 3100.00);

-- Insert Books
INSERT INTO books (title, author, isbn, publication_year) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '978-0-7432-7356-5', 1925),
('To Kill a Mockingbird', 'Harper Lee', '978-0-06-112008-4', 1960),
('1984', 'George Orwell', '978-0-452-28423-4', 1949),
('Pride and Prejudice', 'Jane Austen', '978-0-14-143951-8', 1813),
('The Catcher in the Rye', 'J.D. Salinger', '978-0-316-76948-0', 1951);

-- Insert Book Borrowings (some recent, some old)
INSERT INTO book_borrowings (book_id, borrower_name, borrow_date, return_date) VALUES
(1, 'John Doe', '2023-08-15', '2023-09-15'),
(2, 'Jane Smith', '2023-07-20', '2023-08-20'),
(3, 'Mike Johnson', '2023-09-10', '2023-10-10'),
(1, 'Sarah Wilson', '2023-02-15', '2023-03-15'),  -- Old borrowing
(4, 'David Brown', '2023-01-10', '2023-02-10');  -- Old borrowing
-- Note: Book 5 has never been borrowed

-- Insert Students
INSERT INTO students (student_name, score) VALUES
('Alice Johnson', 95),
('Bob Smith', 87),
('Carol Brown', 76),
('David Wilson', 82),
('Eva Garcia', 91),
('Frank Miller', 68),
('Grace Lee', 59),
('Henry Davis', 73),
('Ivy Chen', 88),
('Jack Taylor', 45);

