/*Basic querying*/

Create Table Employee 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
);

Create Table Salary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
);


Insert into Employee VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');

Insert Into Salary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);

SELECT * FROM Employee;
SELECT * FROM Salary;
SELECT * FROM Salary
WHERE Salary>60000;

SELECT TOP 3 * FROM Salary;

SELECT DISTINCT (Gender)  FROM Employee;

SELECT COUNT(Employee.LastName) FROM  Employee; 

SELECT Gender, COUNT(Gender) AS Number FROM Employee
WHERE Age>30
GROUP BY Gender
ORDER BY Number DESC;

SELECT Employee.Gender, MAX(Salary.Salary) as MaximumSalary FROM Employee LEFT OUTER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID
Group by Employee.Gender
Order by MaximumSalary DESC;;

SELECT Employee.EmployeeID, Employee.Gender, AVG(Salary.Salary) as AverageSalary FROM Employee LEFT OUTER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID
Group by Employee.Gender
Order by AverageSalary DESC;


SELECT * FROM Employee as emp LEFT OUTER JOIN Salary as sal
ON emp.EmployeeID = sal.EmployeeID
ORDER BY emp.EmployeeID ASC;

SELECT sal.JobTitle, AVG(sal.Salary) as AvgSalary FROM Employee as emp LEFT OUTER JOIN Salary as sal
ON emp.EmployeeID = sal.EmployeeID
GROUP BY sal.JobTitle;



/*Intermediate Querying*/

Insert into Employee VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

Insert into Salary VALUES
(1010, NULL, 47000),
(NULL, 'Salesman', 43000)

SELECT * FROM Employee;
SELECT * FROM Salary;

SELECT * FROM Employee INNER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID;

SELECT * FROM Employee LEFT JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID;

SELECT * FROM Employee RIGHT JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID;

SELECT * FROM Employee FULL OUTER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID;

/*Exploring unions by adding a new table*/

Insert into Employee VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male')


Create Table WareHouseEmployee 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)


Insert into WareHouseEmployee VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')

SELECT * FROM Employee;

SELECT * FROM Salary;

SELECT * FROM WareHouseEmployee;

DELETE FROM Employee
WHERE Employee.FirstName IN ('Ryan','Holly','Darryl') ;

SELECT * FROM Employee;

Insert into Employee VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

SELECT * FROM Employee
UNION
SELECT * FROM WareHouseEmployee;

SELECT * FROM Employee FULL OUTER JOIN WareHouseEmployee
ON Employee.EmployeeID=WareHouseEmployee.EmployeeID;

SELECT * FROM Employee
UNION ALL
SELECT * FROM WareHouseEmployee;


SELECT Employee.FirstName,Employee.LastName,Salary.JobTitle,Salary.Salary,
CASE
	WHEN Salary>60000 THEN 'High'
	WHEN Salary BETWEEN 50000 AND 60000 THEN 'Medium'
	WHEN Salary BETWEEN 40000 AND 50000 THEN 'Low'
	ELSE 'Very low'
END AS SalaryBand
FROM Employee INNER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID
ORDER BY SalaryBand DESC;

SELECT JobTitle, AVG(Salary) as AVGSAL FROM Employee INNER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID
GROUP BY JobTitle;

/*Using CTE's*/

WITH salary_per_title(Title,Average_Salary)
AS 
(SELECT JobTitle, AVG(Salary) as AVGSAL FROM Employee INNER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID
GROUP BY JobTitle)
SELECT * FROM salary_per_title
WHERE Title IN ('HR','Salesman');

/*Using temp tables*/

CREATE TABLE #salary_per_title (Title varchar(50) ,Salary_avg int)

INSERT INTO #salary_per_title 
SELECT JobTitle, AVG(Salary) as AVGSAL FROM Employee INNER JOIN Salary
ON Employee.EmployeeID=Salary.EmployeeID
GROUP BY JobTitle;

SELECT Title from #salary_per_title;

/* Exploring STRING functions using Error data table */

--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

-- Using Trim, LTRIM, RTRIM

Select * FROM EmployeeErrors;

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors;

-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors


-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN Employee dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)

-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors



/* Using Subqueries */

Select EmployeeID, JobTitle, Salary
From Salary

-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From Salary) as AllAvgSalary
From Salary

-- Using Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From Salary

-- Using Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From Salary
Group By EmployeeID, Salary
order by EmployeeID


-- Subquery in From

Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From Salary) a
Order by a.EmployeeID


-- Subquery in Where


Select EmployeeID, JobTitle, Salary
From Salary
where EmployeeID in (
	Select EmployeeID 
	From Employee
	where Age > 30)
