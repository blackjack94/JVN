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
FROM Orders JOIN `Order Details` 
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
FROM Employees LEFT JOIN EmployeeTerritories
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
CREATE OR REPLACE VIEW SuppliersNations AS
SELECT DISTINCT Country
FROM Suppliers
WHERE Country IS NOT NULL;

SELECT *
FROM Customers
WHERE Country NOT IN (SELECT * FROM SuppliersNations)
	  OR Country IS NULL;

# Remark: I use Nullity-check because Null's comparisons are always Null (never True)
# => IN () will malfunction.
# MOREOVER, Customer who doesn't have data on Country should also be listed.

# Q11. Find the Company name(s), who has bought more than 50% products (ProductName)
# that we have, and how many products they have bought?
SELECT Customers.CompanyName,
	   COUNT(DISTINCT Products.ProductID) as bought_products_count
FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
			   LEFT JOIN `Order Details` ON Orders.OrderID = `Order Details`.OrderID
			   LEFT JOIN Products ON `Order Details`.ProductID = Products.ProductID
GROUP BY Customers.CustomerID
HAVING bought_products_count > 0.5 * (SELECT COUNT(DISTINCT ProductName) FROM Products);

# Q12. Find the names of Employees who sold the most in each Category names and their
# total sales (amount of money).
CREATE OR REPLACE VIEW EmployeesSalesByCategories AS
SELECT CONCAT(Employees.FirstName, ' ', Employees.LastName) AS employee_name,
	   Categories.*,
       SUM(`Order Details`.Quantity * `Order Details`.UnitPrice) AS total_sales
FROM Categories LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
				LEFT JOIN `Order Details` ON Products.ProductID = `Order Details`.ProductID
				LEFT JOIN Orders ON `Order Details`.OrderID = Orders.OrderID
				LEFT JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Employees.EmployeeID, Categories.CategoryID;

SELECT CategoryName, employee_name, total_sales
FROM EmployeesSalesByCategories JOIN (SELECT CategoryID, MAX(total_sales) as max_total_sales
									  FROM EmployeesSalesByCategories
									  GROUP BY CategoryID) AS tmp
	 ON EmployeesSalesByCategories.CategoryID = tmp.CategoryID
     AND EmployeesSalesByCategories.total_sales = tmp.max_total_sales;

# Q13. Table 'Order' is used the most.
# WHY? I searched for 'FROM' on the whole script,
# then count each used table manually and compare.
# EXPLANATION: It has many FKs, each refers to a key-table,
# such as Employees, Customers, OrderDetails (& Orders, indirectly)

# Q14. The database is in Third Normal Form
# 1. All tables are in 2NF
# 2. All non-key attributes are directly depended key => 3NF
# 3. Non-key PostalCode infers Country, City, Region (table Employees). => Violates BCNF