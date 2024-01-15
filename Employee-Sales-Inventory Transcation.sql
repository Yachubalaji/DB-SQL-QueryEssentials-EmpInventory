
USE Employee_database;

#Aggregate,join,subjoin,view,stored procedure,view,Sub query ,CRED functionalites queries were executed with examples

# Writing the queryTo show the number of orders as we are using count(), and it is aggregate function ,we are using group by to group by month of order date and before that we are using join query to join orderline_t and order table, and then we use where condition
# to choose dates between 2017 year.And then we use order by query to order by salesperson id and month

#Groupby,Orderby- Aggregate function

select * from salesperson_t;
select * from orderline_t; 
select * from order_t;

select SalespersonID,count(O.OrderID),month(O.OrderDate) from order_t as O join orderline_t as OD on O.OrderId = OD.OrderID
where O.OrderDate Between '2017-01-01' and '2017-12-31'
group by O.SalespersonID,month(O.OrderDate) 
order by O.SalespersonID,month(O.OrderDate);



#Writing the query to find the order id, customer id, customer name and order date we are using join query
#to join the table and then use where condition betwee the month of 2018 year.

#Join function

select * from order_t;
select * from customer_t;

select O.orderID,O.CustomerID,CU.CustomerName,O.OrderDate from order_t as O join customer_t as CU on O.CustomerID = CU.CustomerID 
where O.OrderDate between '2018-09-01' and '2018-09-30';
 



#Writing the query We are finding the productid,product description,product finish and product standard price
#using where condition with brackets inside, where query which inside the bracket, will execute first and then outside the query.
 
#Subquery function

select * from product_t;

select P.ProductID,P.ProductDescription,P.ProductFinish,P.ProductStandardPrice from product_t as P 
where (P.ProductFinish ='Oak' and P.ProductStandardPrice >= 400) or (P.ProductFinish ='Cherry' and P.ProductStandardPrice < 300);




#Writing the query to find customerid, name,countof orderid, with also customers not having any orders, so for dislaying this condition 
#we usually use left or right join, here we use right join to all show values on right table with customers no orders also. 
      
select * from customer_t;
select * from order_t;


select CU.CustomerID,CU.CustomerName,count(OrderID)
from order_t as O right join customer_t as CU on CU.customerID = O.customerID group by CU.customerID,CU.CustomerName;



#Writing the query  so that we use to join the table for order_t and customer_t and then as per question to search for productid using IN function
#and then we use count function to calculate the person who has ordered with same product and also in ordered quantity some are 0 , so we use
#conditon to check ordered quantity is greater than 0

#Groupby,where,having - Aggregate function

select * from order_t;
select * from orderline_t;

select C.CustomerID,C.CustomerName
from `order_t` as O 
join `orderline_t` as OD ON O.OrderID= OD.OrderID
join `customer_t` as C on C.CustomerID=O.CustomerID
#where OD.ProductID is 3 and 4
where OD.ProductID in (3,4)  and OD.OrderedQuantity > 0
group by OD.OrderID
having count(*)>1;


#Writing the query. to list the ID and description of all products that cost less than average where we are using sub query concept

#Join ,Left-Right join function


select * from supplies_t;
select * from vendor_t;
select * from rawmaterial_t ;

select VE.VendorID,VE.VendorName, T.MaterialID, T.MaterialName, SU.SupplyUnitPrice 
from vendor_t VE 
join supplies_t SU on VE.VendorID = SU.VendorID
join (
select R.MaterialID, R.MaterialName
from rawmaterial_t as R 
join supplies_t as S on S.MaterialID=R.MaterialID 
join vendor_t as V on V.VendorID = S.VendorID
group by R.MaterialID
having count(V.VendorID)>1
) T on T.MaterialID=SU.MaterialID;


# Writing the query to list the and view productid and product description that cost less than average, 
#first we use sub query function to choose avg of standard price and then we use select function which is less than average

select * from product_t;

select P.ProductID,P.ProductDescription,P.ProductStandardPrice from product_t as P 
where P.ProductStandardPrice < (select avg(P.ProductStandardPrice) from product_t as P);



# Writing the query we are creating a view , before that we select the salesperson id and their name and doing sub query by joining the table order_t ,salesperson_t ,product_ as to get the common fields
#and then we put the condition with where function using %like% function to choose the words computer desk,and then grouping by as a aggregate function to get the max of ordered quantity value

#View Function

select * from salesperson_t;
select * from order_t;
select * from product_t;
select * from orderline_t;

Drop view if exists BestCompSalesPerson;
create view BestCompSalesPerson as (

select SalespersonID,SalespersonName from (
select S.SalespersonID, S.SalespersonName,Max(OrderedQuantity)
from salesperson_t as S 
join order_t as O on S.SalespersonID = O.SalespersonID
join orderline_t as OL on O.OrderID=OL.OrderID
join product_t as P on P.ProductID = OL.ProductID
where P.ProductDescription like '%computer desk%'
group by S.SalespersonID, S.SalespersonName)`Table`);







# Writing out query where we are finding the information of all employees in each state except last hired, so we
#use self join as e1 and then we use e2  as a part to sort out most hired employees and then we use not in function so it will display all values
#except the most recent hired employee

#Left and Right join subquery

select * from employee_t;

select * from employee_t
where EmployeeID not in (

-- Most recently hired employee 
SELECT E1.EmployeeID
FROM employee_t as E1                    
  LEFT JOIN employee_t as E2             
      ON E1.EmployeeState = E2.EmployeeState 
      AND E1.EmployeeDateHired < E2.EmployeeDateHired
WHERE E2.EmployeeDateHired is NULL

);


   
     


 #Writing query Case concept, where we are creating a case in which we write a if esle query concept to list the MaterialName, MaterialID,
 #,Material,MaterialStandardprice with the average materialstandardprice for its material
 
 #Case function

select * from rawmaterial_t;
select distinct material from rawmaterial_t;
 
 
 select MaterialID,MaterialName,Material,MaterialStandardPrice, 
 CASE
 WHEN Material='Ash' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Ash')
 WHEN Material='Birch' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Birch')
 WHEN Material='Cherry' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Cherry')
 WHEN Material='Oak' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Oak')
 WHEN Material='Pine' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Pine')
 WHEN Material='Walnut' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Walnut')
 WHEN Material='Walnut' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Walnut')
 WHEN Material='Mahogany' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Mahogany')
 WHEN Material='Labor' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Labor')
 WHEN Material='Upholstery Adhe' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Upholstery Adhe')
 WHEN Material='Common Nail' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Common Nail')
 WHEN Material='Finish Nail' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Finish Nail')
 WHEN Material='Oval Wire Nail' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Oval Wire Nail') 
 WHEN Material='Staples' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Staples')
 WHEN Material='Upholstery Tack' then (Select avg(MaterialStandardPrice) from rawmaterial_t where Material='Upholstery Tack')
 
 else (select avg(MaterialStandardPrice) from rawmaterial_t )
 END as avgprice
 from rawmaterial_t
 order by MaterialName,MaterialID;
 

 


#Writing a query where ,we are building a stored procedure where we created the create procedure in the procedures tab under this schema and
#then as per question we need to show customers who have not placed any orders, for that we use left join from getting the values from table
#and then we use is null function to get 0 values  
 
 
#Stored Procedure
 
DELIMITER //
Drop procedure if exists `NoShowCustomer`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `NoShowCustomer`()
BEGIN
	select c.CustomerID, c.CustomerName,O.orderID
	from customer_t c
	left join order_t o on c.CustomerID = o.CustomerID
	where o.CustomerID is null;
END //
DELIMITER ;

select * from order_t;
select * from customer_t;

Call NoShowCustomer();



        


#Writing query where we are building  a trigger function, that whenever the values changes the table will show the updated value.Here we are building a table
#audittrails_rawmaterial and then creating fields along with previous and currentprice .So as per syntax we build a trigger function and we use before trigger function 
#to store the previous price of the material and we check with updating material price with the given material id

#Trigger

drop table if exists audittrail_rawmaterials_t;

CREATE TABLE `audittrail_rawmaterials_t` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `MaterialID` varchar(12) NOT NULL,
  Action varchar(50) NOT NULL,
  `PreviousPrice` DECIMAL(6,2) NOT NULL,
  `CurrentPrice` DECIMAL(6,2) NOT NULL,
  `ChangeDate` DATETIME NOT NULL,
  PRIMARY KEY (`Id`));

DROP TRIGGER if exists before_rawmaterial_t_update;

CREATE TRIGGER before_rawmaterial_t_update
	BEFORE UPDATE ON rawmaterial_t
FOR EACH ROW
INSERT INTO `audittrail_rawmaterials_t`
Set Action = 'update',
MaterialID=OLD.MaterialID,
PreviousPrice = OLD.MaterialStandardPrice,
CurrentPrice = NEW.MaterialStandardPrice,
changeDate=NOW();

update rawmaterial_t set MaterialStandardPrice = 40 where MaterialID = '1-1/21010OAK';
select * from audittrail_rawmaterials_t;
select * from RawMATERIAL_t;




#We build a function where we need to build a kind of case if else function where it will return the material class superior ,good and standard using if else condition

#Function 

DELIMITER //
DROP FUNCTION IF EXISTS `func_get_material_class`;
CREATE DEFINER=`root`@`localhost` FUNCTION `func_get_material_class`(Thickness varchar(50), Width varchar(50)) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE MaterialClass VARCHAR(20);

	IF Thickness = '1-1/2' AND (Width = 10 OR Width = 12) THEN 
		SET MaterialClass = 'Superior';
	ELSEIF Thickness = '1/2' AND Width > 8 THEN     
		SET MaterialClass= 'Good';
	ELSE SET MaterialClass= 'Standard';
	END IF;

	Return MaterialClass;
END //

DELIMITER ;


select thickness,width,func_get_material_class(thickness,width) from rawmaterial_t;





#Writing the query , we are creating transcation for commit and rollback, so we create and insert values into it, and then we insert the values
# for first insert,second insert, third insert where for we have have given rollback to insert and at last we provide commit to save these functions and e

#Commit and rollback
Drop table if exists `faculty_t`;
create table `faculty_t`(
`name` varchar(50),
age int,
`department` varchar(50),
`location` varchar(50));

Insert into `faculty_t` (`name`,age,department,location) values ('dhoni',47,'cse','chennai');
select * from faculty_t;


SET autocommit=0;

START TRANSACTION;


insert into faculty_t (name, age, department, location) values ('fc2', 31, 'mech','madurai');
insert into faculty_t (name, age, department, location) values ('fc3', 32, 'ece','trichy');
insert into faculty_t (name, age, department, location) values ('fc4', 33, 'it','coimbatore');
insert into faculty_t (name, age, department, location) values ('fc5', 34, 'civil','delhi');
insert into faculty_t (name, age, department, location) values ('fc6', 35, 'industrial','bangalore');

Rollback;

COMMIT;

START TRANSACTION;


insert into faculty_t (name, age, department, location) values ('fc2', 31, 'mech','madurai');
insert into faculty_t (name, age, department, location) values ('fc3', 32, 'ece','trichy');
insert into faculty_t (name, age, department, location) values ('fc4', 33, 'it','coimbatore');
insert into faculty_t (name, age, department, location) values ('fc5', 34, 'civil','delhi');
insert into faculty_t (name, age, department, location) values ('fc6', 35, 'industrial','bangalore');

commit;

select * from faculty_t;


#From the given question, we need to create transcation for commit and rollback, so we create and insert values into it, and then we insert the values
# for first insert,second insert, third insert where for we have have given rollback to insert and at last we provide commit to save these functions and execute

