###################################
# Course ICT536
# Assignment 2
# Student Name: Le Ta Dang Khoa
# Email: khoa.le2017@ict.jvn.edu.vn
###################################

# Q1. List all product names that have less than 15 units in stock.
SELECT ProductName
FROM Products
WHERE UnitsInStock < 15;

# Q2. Find all the employees who have the phone extension start with number 5.
SELECT *
FROM Employees 
WHERE Extension LIKE '5%';

# Q3. Get the latest 10 orders base on the order date.
SELECT * 
FROM Orders 
ORDER BY OrderDate DESC 
LIMIT 10;

# Q4. List all Customers who from Stuttgart, Seattle, Sao Paulo, Toulouse, Barcelona.
SELECT *
FROM Customers
WHERE City IN ('Stuttgart', 'Seattle', 'Sao Paulo', 'Toulouse', 'Barcelona');

# Q5. List all the Orders that have the total value over 10,000.
SELECT Orders.*, SUM(UnitPrice * Quantity) AS total_value
FROM Orders RIGHT JOIN `Order Details`
	 ON Orders.OrderID = `Order Details`.OrderID
GROUP BY Orders.OrderID
HAVING total_value > 10000;

# Q6. Find the oldest employee(s) of our company.
SELECT *
FROM Employees
WHERE BirthDate = (SELECT MIN(BirthDate) FROM Employees);

# Q7. List all the Employees who have a BA degree.
SELECT *
FROM Employees
WHERE Notes LIKE '% BA %';

# Q8. What is the full information of the employee(s) who manage the most number of 
# territory, how many is it?
SELECT Employees.*, COUNT(EmployeeTerritories.EmployeeID) AS total_manage
FROM Employees JOIN EmployeeTerritories
	 ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
GROUP BY Employees.EmployeeID
ORDER BY total_manage DESC
LIMIT 1;

# Q9. Get all product’ category IDs and its total Unit in stock and total Unit on order that
# have total unit on order pass over 30% of total unit in stock.
SELECT Categories.CategoryID, 
	   SUM(Products.UnitsInStock) as total_in_stock, SUM(Products.UnitsOnOrder) as total_on_order
FROM Categories LEFT JOIN Products
	 ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryID
HAVING total_on_order > 0.3 * total_in_stock;

# 10. Create a view to extract all national location of our suppliers. Then use that view to
# find out who of our customers do not have a supplier in their countries.
CREATE VIEW [Suppliers Nations] AS
SELECT Coun
FROM Su