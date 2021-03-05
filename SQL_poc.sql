 CREATE TABLE Cart
(
   Cart_id VARCHAR(7) NOT NULL,
   PRIMARY KEY(Cart_id)
);


GO

CREATE TABLE Customer
(
   Customer_id VARCHAR(6) NOT NULL,
   c_pass VARCHAR(10) NOT NULL,
   Name VARCHAR(20) NOT NULL,
   Address VARCHAR(20) NOT NULL,
   Pincode NUMERIC(6) NOT NULL,
   Phone_number_s NUMERIC(10) NOT NULL,
   PRIMARY KEY (Customer_id),
   Cart_id VARCHAR(7) NOT NULL,
   FOREIGN KEY(Cart_id) REFERENCES cart(Cart_id)
);

GO

CREATE TABLE Payment
(
   payment_id VARCHAR(7) NOT NULL,
   payment_date DATE NOT NULL,
   Payment_type VARCHAR(10) NOT NULL,
   Customer_id VARCHAR(6) NOT NULL,
   Cart_id VARCHAR(7) NOT NULL,
   PRIMARY KEY (payment_id),
   FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
   FOREIGN KEY (Cart_id) REFERENCES Cart(Cart_id),
   total_amount numeric(6)
);

GO

CREATE TABLE Product
(
   Product_id VARCHAR(7) NOT NULL,
   Product_Type VARCHAR(7) NOT NULL,
   Cost NUMERIC(5) NOT NULL,
   Quantity NUMERIC(2) NOT NULL,
   PRIMARY KEY (Product_id),
);

GO

CREATE TABLE Cart_item
(
    Quantity_wished NUMERIC(1) NOT NULL,
    Date_Added DATE NOT NULL,
    Cart_id VARCHAR(7) NOT NULL,
    Product_id VARCHAR(7) NOT NULL,
    FOREIGN KEY (Cart_id) REFERENCES Cart(Cart_id),
    FOREIGN KEY (Product_id) REFERENCES Product(Product_id),
    Primary key(Cart_id,Product_id)
);

GO

CREATE TABLE UserType 
(  
   UserTypeID int IDENTITY(1,1) PRIMARY KEY,  
   UserTypeName varchar(20) NOT NULL   
);

GO

CREATE TABLE UserMaster
(  
	UserID int IDENTITY(1,1) PRIMARY KEY,  
	FirstName varchar(20) NOT NULL ,
	LastName varchar(20) NOT NULL,
	Username varchar(20) NOT NULL,
	Password varchar(40) NOT NULL,
	Gender varchar(6) NOT NULL,
	UserTypeID int NOT NULL,   
);

GO

alter table Cart_item add purchased varchar(3) default 'NO'

GO 

alter table Product alter column Product_Type varchar(20) NOT NULL;


--  DEMO VALUES
--insert into Cart values('crt1011');
GO
--insert into Customer values('cid100','ABCD1235','Abhijit','G-453','632014',9893135876, 'crt1011');
GO
--insert into Product values('pid1001','Vegetables',105,5);
GO
--insert into Cart_item values(3,'1-Feb-2021','crt1011','pid1001','Y');
GO
--insert into Payment values('pmt1001','1-Feb-2021','online','cid100','crt1011',NULL);
GO
-- insert into UserType VALUES('Admin'),('User'); 
GO
-- insert into UserMaster VALUES('Abhijit','Shinde','adminuser','qwerty','Male',1); -- Add the record for Admin user.

GO

-- If the customer wants to see details of product present in the cart
    select * from product where product_id in(
        select product_id from Cart_item where (Cart_id in (
            select Cart_id from Customer where Customer_id='cid100'
        )) and purchased='NO');

GO

-- If a customer wants to see order history
	select product_id,Quantity_wished from Cart_item where (purchased='Y' and Cart_id in (select Cart_id from customer where Customer_id='cid101'));
GO
-- If customer wants to modify the cart
	delete from cart_item where (product_id='pid1001' and Cart_id in (select cart_id from Customer where Customer_id='cid100'));
GO
-- If admin wants to see what are the product purchased on the particular date
	 select product_id from cart_item where (purchased='Y' and date_added='1-Feb-2021');
GO
-- How much product sold on the particular date
	select count(product_id) count_pid,date_added from Cart_item where purchased='Y'  group by(date_added);
GO
-- If a customer want to know the total price present in the cart
	select sum(quantity_wished * cost) total_payable from product p join cart_item c on p.product_id=c.product_id where c.product_id in (select product_id from cart_item where cart_id in(select Cart_id from customer where customer_id='cid101') and purchased = 'Y');
GO
-- Find total profit of the website from sales
	select sum(quantity_wished * cost) total_profit from product p join cart_item c on p.product_id=c.product_id where purchased='Y';


-- Trigger to update the total amount of user everytime he adds something to payment table

    /*create or replace function total_cost(cId in varchar)
    return number
    is
    total numeric(2) :=0;
    begin
    select sum(cost) into total from product,cart_item where product.product_id=cart_item.product_id and cart_id=cId;
    return total;
    end;

    create or replace trigger before_pay_up
    before insert
    on
    payment
    for each row
    declare
    total numeric(3);
    begin
    total :=total_cost(:new.cart_id);
    insert into payment values(:new.payment_id,:new.payment_date,:new.payment_type,:new.customer_id,:new.cart_id,total);
    end; */

 -- Function to count number of cart items

   /* create or replace function numCartId(cd in varchar)
    return number
    is
    total numeric(2):=0;
    begin
    select count(*) into total from cart_item where cart_id=cd;
    return total;
    end;

 -- Trigger
    Create or replace trigger before_customer
    before insert
    on
    customer
    for each row
    declare
    c varchar(10);
    n numeric(2);
    begin
    c:= :new.cart_id;
    n:=numCartId(c);
    if n>0 
	PRINT N'Sorry';
    else;
    insert into cart values(c);
    end; */

	