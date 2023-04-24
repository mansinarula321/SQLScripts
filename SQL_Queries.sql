SELECT emp1.firstName employeeFirstName,emp1.lastName employeeLastName,
emp2.firstName managerFirstName, emp2.lastName managerLastName
FROM employee emp1
INNER JOIN employee emp2
ON emp1.employeeId=emp2.managerId;

SELECT *FROM sales LIMIT 5;

SELECT emp1.firstName,emp1.lastName
FROM employee emp1
LEFT OUTER JOIN sales
ON emp1.employeeId = sales.employeeId
WHERE sales.employeeId IS NULL
AND emp1.title = 'Sales Person';

SELECT sales.*,customer.* FROM sales LEFT OUTER JOIN customer
ON sales.customerId=customer.customerId
WHERE customer.customerId IS NULL
UNION
SELECT sales.*,customer.* FROM customer LEFT OUTER JOIN sales
ON sales.customerId=customer.customerId
WHERE sales.customerId is NULL
UNION
SELECT sales.*,customer.* FROM customer INNER JOIN sales
ON sales.customerId=customer.customerId;

/*How many cars have been sold per employee*/

select * from sales limit 5;

SELECT employee.firstName,employee.lastName, COUNT(*) carsSold
FROM employee INNER JOIN sales
ON employee.employeeId=sales.employeeId
GROUP BY employee.firstName,employee.lastName
ORDER BY carsSold DESC;

select * from sales limit 5;

select employee.firstName,employee.lastName,
MIN(sales.salesAmount) leastExpensive,MAX(sales.salesAmount) mostExpensive
FROM employee INNER JOIN sales
ON employee.employeeId=sales.employeeId
WHERE sales.soldDate >=date('now','start of year')
GROUP BY employee.firstName,employee.lastName;

SELECT employee.firstName,employee.lastName,count(sales.employeeId) numberOfCarsSold
FROM employee INNER JOIN sales
ON employee.employeeId = sales.employeeId
WHERE sales.soldDate >=date('now','start of year')
GROUP BY employee.firstName,employee.lastName
HAVING numberOfCarsSold >5;


select sum(salesAmount)),strfTime('%Y',soldDate) sale_year from sales
 group by sale_year;

 select * from sales limit 5;
 select * from employee limit 5;
select * from inventory limit 5;
select * from model limit 5;


select employee.firstName,employee.lastName,model,
rank() OVER(PARTITION by sales.employeeId
 ORDER BY count(model) DESC) AS model_rank
from employee,sales,inventory,model
where employee.employeeId=sales.employeeId
AND sales.inventoryId=inventory.inventoryId
AND model.modelId=inventory.inventoryId
group by employee.firstName,employee.lastName
order by employee.firstName


WITH cte as
(select
sum(sales.salesAmount) AS monthlySoldAmount,
strftime('%m',soldDate) AS soldMonth,strfTime('%Y',soldDate) AS soldYear
from sales
group by soldMonth,soldYear)
select soldMonth,soldYear,monthlySoldAmount,
sum(monthlysoldAmount) OVER (partition by soldYear ORDER BY soldMonth) AS runningTotal
from cte
group by soldMonth,soldYear,monthlySoldAmount
order by soldYear,soldMonth;


WITH CTE AS
(select strftime('%Y-%m',soldDate) AS monthSold,count(inventoryId) AS NumberOfCarsSold
 from sales
 group by monthSold)
 select monthSold,NumberOfCarsSold,lag(NumberOfCarsSold,1,0) OVER (ORDER BY monthSold) AS LastMonthCarsSold
 from cte;
