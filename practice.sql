-- Create Customer table with primary key and created_at timestamp
CREATE TABLE Customer (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Product table with a check constraint to ensure price > 0
CREATE TABLE Product (
    id INT PRIMARY KEY ,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2) CHECK (price > 0),
    stock INT,
    category VARCHAR(50)
);

-- Create OrderItem table with foreign keys referencing Order and Product
CREATE TABLE public.Order (
    id INT PRIMARY KEY ,
    customer_id INT,
    order_date DATE,
    status VARCHAR(50),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customer(id)
);

CREATE TABLE OrderItem (
    id INT PRIMARY KEY ,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES public.Order(id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);
-- Create Payment table
CREATE TABLE Payment (
    id INT PRIMARY KEY,
    order_id INT,
    payment_mode VARCHAR(50),
    amount_paid DECIMAL(10, 2),
    payment_status VARCHAR(50),
    paid_on DATE,
    FOREIGN KEY (order_id) REFERENCES public.Order(id)
);
-- Alter Customer table to add loyalty_points column
ALTER TABLE Customer ADD COLUMN loyalty_points INT DEFAULT 0;

-- Alter Product table to rename column category to product_category
ALTER TABLE Product RENAME COLUMN category TO product_category;


-- Customer table insertions
INSERT INTO Customer (id,name, email, phone, address) VALUES
(1,'John Doe', 'john@email.com', '555-0101', '123 Main St, City'),
(2,'Jane Smith', 'jane@email.com', '555-0102', '456 Oak Ave, Town'),
(3,'Mike Johnson', 'mike@email.com', '555-0103', '789 Pine Rd, Village'),
(4,'Sarah Williams', 'sarah@email.com', '555-0104', '321 Elm St, County'),
(5,'Robert Brown', 'robert@email.com', '555-0105', '654 Maple Dr, State');

-- Product table insertions
INSERT INTO Product (id,name, description, price, stock, product_category) VALUES
(1,'Laptop Pro', 'High-end laptop with 16GB RAM', 1299.99, 10, 'Electronics'),
(2,'Wireless Mouse', 'Bluetooth wireless mouse', 29.99, 50, 'Accessories'),
(3,'USB-C Cable', '1m USB-C charging cable', 15.99, 100, 'Accessories'),
(4,'Monitor 24"', '24-inch HD monitor', 199.99, 15, 'Electronics'),
(5,'Keyboard', 'Mechanical gaming keyboard', 89.99, 30, 'Electronics');

-- Order table insertions
INSERT INTO public.Order (id,customer_id, order_date, status, total_amount) VALUES
(1,1, '2025-04-14', 'Completed', 1329.98),
(2,2, '2025-04-14', 'Pending', 215.98),
(3,3, '2025-04-13', 'Shipped', 89.99),
(4,4, '2025-04-13', 'Processing', 199.99),
(5,5, '2025-04-12', 'Completed', 45.98);

-- OrderItem table insertions
INSERT INTO OrderItem (id,order_id, product_id, quantity, unit_price) VALUES
(1,1, 1, 1, 1299.99),
(2,1, 2, 1, 29.99),
(3,2, 4, 1, 199.99),
(4,2, 3, 1, 15.99),
(5,3, 5, 1, 89.99);

-- Payment table insertions
INSERT INTO Payment (id,order_id, payment_mode, amount_paid, payment_status, paid_on) VALUES
(1,1, 'Credit Card', 1329.98, 'Completed', '2025-04-14'),
(2,2, 'PayPal', 215.98, 'Pending', '2025-04-14'),
(3,3, 'Debit Card', 89.99, 'Completed', '2025-04-13'),
(4,4, 'Credit Card', 199.99, 'Processing', '2025-04-13'),
(5,5, 'Bank Transfer', 45.98, 'Completed', '2025-04-12');


-- Insert a new product into the Product table
INSERT INTO Product (id,name, description, price, stock, product_category)
VALUES (6,'socks', 'wearable', 120.00, 10, 'Clothes');

-- Update the stock of a product after an order is placed
UPDATE Product
SET stock = stock - 2
WHERE id = 1; -- Assuming product ID 1


-- Drop existing foreign key constraints
ALTER TABLE public.Order 
    DROP CONSTRAINT IF EXISTS order_customer_id_fkey;

ALTER TABLE OrderItem
    DROP CONSTRAINT IF EXISTS orderitem_order_id_fkey,
    DROP CONSTRAINT IF EXISTS orderitem_product_id_fkey;

ALTER TABLE Payment
    DROP CONSTRAINT IF EXISTS payment_order_id_fkey;

-- Add new foreign key constraints with custom names
ALTER TABLE public.Order
    ADD CONSTRAINT fk_order_customer
    FOREIGN KEY (customer_id) 
    REFERENCES Customer(id) 
    ON DELETE CASCADE;

ALTER TABLE OrderItem
    ADD CONSTRAINT fk_orderitem_order
    FOREIGN KEY (order_id) 
    REFERENCES public.Order(id) 
    ON DELETE CASCADE,
    ADD CONSTRAINT fk_orderitem_product
    FOREIGN KEY (product_id) 
    REFERENCES Product(id) 
    ON DELETE CASCADE;

ALTER TABLE Payment
    ADD CONSTRAINT fk_payment_order
    FOREIGN KEY (order_id) 
    REFERENCES public.Order(id) 
    ON DELETE CASCADE;

-- Delete an order and cascade delete corresponding OrderItems
DELETE FROM public.Order WHERE id = 1; -- Assuming order ID 1

-- Insert a payment record linked to a particular order
INSERT INTO Payment (id,order_id, payment_mode, amount_paid, payment_status, paid_on)
VALUES (6,5, 'Credit Card', 2400.00, 'Completed', NOW());

-- Update the status of a customer’s order from 'Pending' to 'Shipped'
UPDATE public.Order
SET status = 'Shipped'
WHERE id = 1; -- Assuming order ID 1

-- Get the list of all orders with the customer name and order total
SELECT o.id AS order_id, c.name AS customer_name, o.total_amount
FROM public.Order o
JOIN Customer c ON o.customer_id = c.id;

-- List all products that are out of stock
SELECT * FROM Product
WHERE stock = 0;

-- Find all customers who haven’t placed any orders yet
SELECT * FROM Customer
WHERE id NOT IN (SELECT customer_id FROM public.Order);

-- Get top 3 customers who have spent the most money
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM public.Order o
JOIN Customer c ON o.customer_id = c.id
GROUP BY c.id
ORDER BY total_spent DESC
LIMIT 3;

-- Get the details of the highest value order
SELECT *
FROM public.Order
ORDER BY total_amount DESC
LIMIT 1;

