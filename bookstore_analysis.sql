-- =========================
-- DATABASE SETUP
-- =========================

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

-- =========================
-- BASIC QUERIES
-- =========================

-- Q1: Retrieve all books in the "Fiction" genre
SELECT title, genre
FROM Books
WHERE genre = 'Fiction';

-- Q2: Find books published after the year 1950
SELECT title, genre, published_year
FROM Books
WHERE published_year > 1950;

-- Q3: List all customers from Canada
SELECT name, country
FROM Customers
WHERE country = 'Canada';

-- Q4: Show orders placed in November 2023
SELECT customer_id, order_date
FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- Q5: Retrieve the total stock of books available
SELECT SUM(stock) AS total_stock_book_available
FROM Books;

-- Q6: Find the most expensive book
SELECT title, genre, price
FROM Books
ORDER BY price DESC
LIMIT 1;

-- Q7: Show all customers who ordered more than 1 quantity of a book
SELECT c.name, b.title, o.quantity
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Books b ON o.book_id = b.book_id
WHERE o.quantity > 1;

-- Q8: Retrieve all orders where the total amount exceeds $20
SELECT b.title, o.total_amount
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
WHERE o.total_amount > 20;

-- Q9: List all unique genres
SELECT DISTINCT genre
FROM Books;

-- Q10: Find the book with the lowest stock
SELECT title, stock
FROM Books
ORDER BY stock ASC
LIMIT 1;

-- Q11: Calculate total revenue from all orders
SELECT SUM(total_amount) AS total_revenue_generated
FROM Orders;

-- =========================
-- ADVANCED QUERIES
-- =========================

-- Q12: Total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.genre;

-- Q13: Average price of Fantasy books
SELECT AVG(price) AS average_price_of_fantasy
FROM Books
WHERE genre = 'Fantasy';

-- Q14: List customers who placed at least 2 orders
SELECT c.customer_id, c.name, COUNT(*) AS total_orders
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(*) >= 2;

-- Q15: Most frequently ordered book
SELECT b.title, COUNT(*) AS order_count
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY order_count DESC
LIMIT 1;

-- Q16: Top 3 most expensive Fantasy books
SELECT title, price
FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- Q17: Total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS total_quantity_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author
ORDER BY total_quantity_sold DESC;

-- Q18: Cities where customers spent more than $30 on an order
SELECT DISTINCT c.city
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;

-- Q19: Customer who spent the most
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1;

-- Q20: Remaining stock after fulfilling all orders
SELECT b.book_id, b.title,
       b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_stock
FROM Books b
LEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock;