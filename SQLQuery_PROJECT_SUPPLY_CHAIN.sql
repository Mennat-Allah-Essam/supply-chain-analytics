
----VIEWS

/* 1. View: A view that shows all orders with customer details (Order_ID, Customer_Name, State). (Menna)*/
CREATE VIEW Orders_Customers AS
SELECT 
    Order_ID, 
    Customer_Name, 
    State
FROM Retails_orders

SELECT * FROM Orders_Customers


/*2: A view for sales by month (Month_Name, Total_Sales).view and aggregation, (Sabrin)*/

create view salesbymonth 
as
select SUM(ro.Sales) as [Total Sales],cs.Month_Name
from Retails_orders ro,Calendar_Supply cs
where ro.Order_Date=cs.Date
group by cs.Month_Name

select * 
from salesbymonth



/*3: A view that shows the top-selling products (Product_Name, SUM(Quantity), (Farah)*/

CREATE VIEW QTY
AS
SELECT SUM(R.Quantity) AS QTYY, R.Product_Name
FROM Retails_orders R
GROUP BY R.Product_Name

SELECT * FROM QTY
ORDER BY QTYY DESC


/*4: A view that shows profit by each Region. (Habiba)*/
create view profit_by_region as 
select
      Region ,
	  sum (sales - cost ) as total_profit
from  Retails_orders
group by Region;

select * from profit_by_region


/*5: A view that shows the (Average Discount) for each Segment.(Shrouk)*/
CREATE VIEW AVGdiscountpersegment as 
select 
segment ,
AVG(Discount)AS averagediscount 
from Retails_orders
Group by Segment 

select * from AVGdiscountpersegment 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
------JOINS


/*1: Retail_Orders × Calendar_Supply ? show each order with its corresponding Day_Name and Month_Name.(Farah)*/
SELECT R.Order_ID, R.Product_Name, C.Day_Name, C.Month_Name
FROM Retails_orders R INNER JOIN Calendar_Supply C
ON R.Order_Date = C.Date




 /*2: show all calendar dates, even if no orders were placed on some days. (Sabrin)*/
select cs.*,ro.Order_ID
from Calendar_Supply  cs left join Retails_orders ro
on cs.Date=ro.Order_Date



/*3: show all states with their coordinates, even if some states don’t have any orders. (Habiba)*/
SELECT 
    sc.Name,
    sc.latitude,
    sc.longitude,
    ro.order_id,
    ro.customer_id,
    ro.order_date
FROM STATE_COORDS sc
LEFT JOIN Retails_orders ro
    ON sc.Name = ro.state


 /*4:Right Join: Retail_Orders RIGHT JOIN Calendar_Supply ? show all dates, including ones with no orders, along with orders if they exist. (Menna)*/
SELECT 
    c.Date, 
    c.Year, 
    r.Order_ID, 
    r.Customer_Name, 
    r.Sales
FROM Calendar_Supply c
RIGHT JOIN Retails_orders r
    ON c.Date = r.Order_Date



/*5: show all states and all orders, even if a state has no orders or an order has no matching state.(Shrouk)*/

SELECT 
    sc.state AS StateCode,
    sc.latitude,
    sc.longitude,
    sc.Name AS StateName,
    ro.[Order_ID],
    ro.[Customer_ID],
    ro.[Order_Date],
    ro.Sales
FROM State_Coords sc
FULL OUTER JOIN Retails_orders ro
    ON sc.State_ID = ro.StateID

-------------------------------------------------------------------------------------------------------------------------
-------DIFF FUNCTIONS

/*1: Function to return total sales for a specific customer (Customer_ID). (Menna)*/

CREATE FUNCTION fn_TotalSales_ByCustomer (@CustomerID NVARCHAR(50))
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TotalSales DECIMAL(18,2)

    SELECT @TotalSales = SUM(Sales)
    FROM Retails_orders
    WHERE Customer_ID = @CustomerID;

    RETURN ISNULL(@TotalSales,0)
END

SELECT dbo.fn_TotalSales_ByCustomer('BN-11515') AS TotalSales




 /*2: Function to return the number of orders in a specific month (Month). (Sabrin)*/
create function return_num_of_order(@month tinyint )
returns table 
as
return
(
select count(*) [Total Orders]
from Retails_orders ro 
where month(ro.Order_Date)=@month
)

select *
from return_num_of_order(5)




/*3: Function to calculate total discounts for a specific product (Product_ID).(Farah)*/
CREATE FUNCTION TOTAL_DISCOUNTSS (@PID nvarchar(50))
RETURNS TABLE 
AS
RETURN
(
SELECT SUM(R.Discount) AS SUM_DISC,R.Product_ID, R.Product_Name
FROM Retails_orders R
WHERE R.Product_ID = @PID
GROUP BY R.Product_ID, R.Product_Name
)

SELECT * FROM  TOTAL_DISCOUNTSS ('TEC-AC-10001142')



/*4: Function to return the highest Profit in a given State. (Shrouk)*/
CREATE FUNCTION GetMaxProfitByState1 (@State NVARCHAR(50))
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @MaxProfit DECIMAL(18,2)

    SELECT @MaxProfit = MAX(r.Profit)
    FROM Retails_orders r
    WHERE r.State = @State 

    RETURN @MaxProfit
END

SELECT dbo.GetMaxProfitByState1('California') AS MaxProfit




/*5: Function to return the total quantity of products sold within a date range. (Habiba)*/
CREATE FUNCTION dbo.TotalQuantitySold
(
    @StartDate DATE,
    @EndDate   DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalQty INT
    SELECT @TotalQty = SUM(r.quantity)
    FROM dbo.Retails_orders r
    WHERE r.order_date BETWEEN @StartDate AND @EndDate

    RETURN ISNULL(@TotalQty, 0)
END

SELECT dbo.TotalQuantitySold('2014-01-01', '2014-01-31')




-------------------------------------------------------------------------------------------------------------------------

-----AGGREGATION FUNCTION

/*1: Total of sales in each month. (Sabrin)*/
select SUM(ro.Sales) as [Total Sales],cs.Month_Name
from Retails_orders ro,Calendar_Supply cs
where ro.Order_Date=cs.Date
group by cs.Month_Name


/* 2: SUM(Quantity) per product. (Menna)*/

SELECT 
    Product_Name, 
    SUM(Quantity) AS TotalQuantity
FROM Retails_orders
GROUP BY Product_Name
ORDER BY TotalQuantity DESC


/*3: COUNT(Order_ID) per customer. (Menna)*/
SELECT 
    Customer_ID, 
    Customer_Name, 
    COUNT(Order_ID) AS OrdersCount
FROM Retails_orders
GROUP BY Customer_ID, Customer_Name
ORDER BY OrdersCount DESC



/*4: COUNT(DISTINCT Customer_ID) per region. (Sabrin)*/

select count(distinct ro.Customer_ID) [number of customer],ro.Region
from Retails_orders ro
group by ro.Region


/*5: AVG(Discount) per sub-category. (Shrouk)*/
SELECT 
    [Sub_Category],
    AVG(Discount) AS AvgDiscount
FROM Retails_orders
GROUP BY [Sub_Category]

/*6: AVG(Sales) per customer.(Farah)*/
SELECT AVG( R.Sales) AS AVG_SALES, R.Customer_ID,
R.Customer_Name
FROM Retails_orders R
GROUP BY R.Customer_ID, R.Customer_Name


/*7: MIN(Order_Date) per customer (first order). (Farah)*/
SELECT
MIN( R.Order_Date) AS
FIRST_ORDER
,R.Customer_ID, R.Customer_Name
FROM Retails_orders R
GROUP BY R.Customer_ID, R.Customer_Name


/*8.MAX(Order_Date) per customer (last order). (Habiba)*/
SELECT MAX(r.Order_Date) AS LastOrderDate , r.Customer_ID, r.Customer_Name
FROM Retails_orders r
GROUP BY r.Customer_ID , r.Customer_Name



/*9.MAX(Sales) for the best-selling product. (Habiba) */
SELECT 
    Product_ID,
    MAX(Sales) AS MaxSales
FROM dbo.Retails_orders
GROUP BY Product_ID
ORDER BY MaxSales DESC

/*10: AVG(Profit) per shipping mode. (Shrouk)*/
SELECT 
    [Ship_Mode],
    AVG(Profit) AS AvgProfit
FROM Retails_orders
GROUP BY [Ship_Mode]
-------------------------------------------------------------------------------------------

---INDEX

/*1: Index on Customer_ID (for faster customer lookup). (Menna)*/
CREATE NONCLUSTERED INDEX idx_CustomerID
ON Retails_orders (Customer_ID)


/* 2: Index on StateID (for filtering by state). (Habiba) */
CREATE INDEX IX_State_Coords_StateID
ON State_Coords (state_id) 

SELECT * 
FROM State_Coords
WHERE State_ID = 5



/*3: Index on Order_Date (for date-based queries). (Sabrin)*/
create nonclustered index idx_orders_date
on Retails_orders (Order_Date)

select *
from Retails_orders 
where Order_Date between '2016-09-01' and '2016-12-12'
order by Order_Date desc



/*4: Index on Segment (for customer segmentation analysis). (Farah)*/
CREATE INDEX SEGMENT_INDEX ON [dbo].[Retails_orders]([Segment])

select * from Retails_orders r
where r.Segment = 'corporate'



/*5: Index on Region (for regional reporting). (Shrouk) */
CREATE NONCLUSTERED INDEX IX_Retails_Orders_Region
ON Retails_Orders ([Region])


--------------------------------------------------------------------------------------------------------------------------------------

---SP


/*1: SP to display sales during a given period (Start_Date, End_Date). (Farah)*/
CREATE PROC SPECIFIC_PERIODS ( @ST_DATE DATE , @END_DATE DATE)
AS
SELECT R.Sales, R.Order_Date, R.Ship_Date
FROM Retails_orders R
WHERE R.Order_Date = @ST_DATE AND R.Ship_Date = @END_DATE 

SPECIFIC_PERIOD '2016-08-11' , '2016-11-11'

SELECT R.Order_Date, R.Ship_Date
FROM Retails_orders R

/* 2: SP to list all orders with a discount greater than X (pass discount %).*/

CREATE PROCEDURE sp_Orders_With_Discount @MinDiscount DECIMAL(5,2)
AS
BEGIN
PRINT 'Stored Procedure Executed Successfully'

    SELECT 
        Order_ID, 
        Customer_Name, 
        Discount, 
        Sales, 
        Profit
    FROM Retails_orders
    WHERE Discount > @MinDiscount
END;

EXEC sp_Orders_With_Discount @MinDiscount = 0.10


/*3: SP to calculate total Profit in a given state.(Sabrin)*/
create proc profit_bystate @state nvarchar(50) 
as
begin
select cast(sum(ro.Profit) as int) as [Total Profit]
from Retails_orders ro 
where ro.State=@state
end

exec profit_bystate 'Delaware'


/*4: SP to display sales by Salesperson. (Habiba)*/

CREATE PROCEDURE dbo.GetSalesBySalescustomer
AS
BEGIN
    SET NOCOUNT ON

    SELECT SUM(r.Sales) AS TotalSales, r.Customer_ID, r.Customer_Name , r.Retail_Sales_People
    FROM Retails_orders r
    GROUP BY r.Customer_ID, r.Customer_Name, r.Retail_Sales_People
    ORDER BY TotalSales DESC;
END

EXEC dbo.GetSalesBySalescustomer;


/*5: SP to update customer information (Update Customer Info). (Shrouk)*/
CREATE PROCEDURE UpdateCustomerInfo22
    @CustomerID NVARCHAR(50),      
    @CustomerName NVARCHAR(100),   
    @Segment NVARCHAR(50)         
AS
BEGIN
    UPDATE Retails_orders
    SET 
        [Customer_Name] = @CustomerName,
        [Segment] = @Segment
    WHERE [Customer_ID] = @CustomerID;
END

EXEC UpdateCustomerInfo22
    @CustomerID = 'CG-12520', 
    @CustomerName = 'Locas', 
    @Segment = 'Corporate'





------------------------------------------------------------------------------------------------------------------------------

--TRIGGERS

/*1: Trigger to RAISE MESSAGE TO NOT EDIT state table. (Sabrin)*/

CREATE TRIGGER do_not_edit
ON [dbo].[State_Coords]
INSTEAD OF UPDATE
AS
SELECT 'Do not edit state table'

UPDATE [dbo].[State_Coords]
set state = 'cairo'



/*2: After Update on Retails_orders (Sales column) ? show the old and new Sales values. (Farah) */

CREATE TRIGGER NEW_SALE
ON [dbo].[Retails_orders]
AFTER UPDATE 
AS
SELECT R.Sales
FROM Retails_orders R

UPDATE [dbo].[Retails_orders]
SET Sales = 4000
WHERE Product_ID = 'FUR-BO-10001798'


UPDATE [dbo].[Retails_orders]
SET Sales = 261.959991455078
WHERE Product_ID = 'FUR-BO-10001798'


SELECT R.Product_Name , R.Product_ID, R.Sales
FROM Retails_orders R


/*3: Trigger to RAISE MESSAGE TO NOT EDIT CALENDAR (Shrouk).*/
CREATE TRIGGER NOT_ALLOWED
ON [dbo].[Calendar_Supply]
INSTEAD OF UPDATE
AS
SELECT 'NOT ALLOWED TO MODIFY CALENDAR TABLE'

UPDATE [dbo].[Calendar_Supply]
SET Date = '2022'

/* 4: Massege after insert. (Habiba)*/
create trigger message_of_insert
on [dbo].[Retails_orders]
after insert 
AS
select 'new row was added!'

insert into [dbo].[Retails_orders] (Row_ID)
values ('9995')


/* 5: Trigger to prevent inserting an Order_Date earlier than a specific allowed date. (Menna)*/

CREATE TABLE TestOrders (
    Order_Date DATE NOT NULL
)

CREATE TRIGGER trg_TestOrders_ValidateDate
ON TestOrders
AFTER INSERT
AS
BEGIN
    DECLARE @minAllowedDate DATE = '2020-01-01'

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Order_Date < @minAllowedDate
    )
    BEGIN
        RAISERROR('Order_Date cannot be earlier than 2020-01-01', 16, 1)
        ROLLBACK TRANSACTION;
    END
END

-- 3. Old Date Trial
INSERT INTO TestOrders (Order_Date)
VALUES ('2019-12-15')

-- 4. New Date Trial
INSERT INTO TestOrders (Order_Date)
VALUES ('2021-05-20')

-- 5. ???? ???? ????? ?????
SELECT * FROM TestOrders



-------------------------------------------------------------------------------------------------------------------------

/*1 STATEMENT: UPDATE ? Increase Discount by 5% for customers in a specific Segment. (Farah) */

UPDATE [dbo].[Retails_orders]
SET Discount += 0.05
WHERE Segment = 'CONSUMER'


UPDATE [dbo].[Retails_orders]
SET Discount -= 0.05
WHERE Segment = 'CONSUMER'


SELECT R.Discount , R.Segment
FROM Retails_orders R






