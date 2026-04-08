-- Data Digger Project
-- E-commerce Database System
-- Author: Mayur

drop database if exists datadigger;
create database datadigger;

use datadigger;

drop table if exists customers;
create table customers(
	customerid int auto_increment primary key,
    name varchar(100) not null,
    email varchar(150) unique,
    address varchar(255)
);

drop table if exists products;
create table products(
	productid int auto_increment primary key,
    productname varchar(150) not null,
    price decimal(10,2) not null check(price>=0),
    stock int not null default 0 check (stock>=0)
);

drop table if exists orders;
create table orders(
	 orderid int auto_increment primary key,
     customerid int not null,
     orderdate date not null,
     totallamount decimal(12,2) not null default 0,
     foreign key (customerid) references customers(customerid)
		on update cascade
        on delete restrict
);

drop table if exists orderdetails;
create table orderdetails(
	orderdetailid int auto_increment primary key,
    orderid int not null,
    productid int not null,
    quantity int not null check (quantity>0),
    subtotal decimal(12,2) not null,
    foreign key (orderid) references orders(orderid)
		on delete cascade
        on update cascade,
	foreign key (productid) references products(productid)
		on update cascade
        on delete restrict
);

insert into customers(name,email,address) values
("makwana mayur","makwana@gmail.com","b3,shantanu"),
("makwana veer","veer@gmail.com","48 prak street,surat"),
("durji vishnubhai","vishu@gmail.com","22 hill view,vadodara"),
("durji ashaben","asha@gmail.com","77 sunrise ,pune"),
("ram rahim","ram_rahim@gmail.com","12 chry lon,mumbai");

insert into products(productname,price,stock) values
("earbuds",499,50),
("leptop gaming",9200,45),
("wireless",1299,40),
("usb-c charger",899,25),
("mechanical keyboard",2599,15);

insert into orders(customerid,orderdate,totallamount) values
(1,"2025-09-01",0),
(2,"2025-09-10",0),
(1,"2025-09-20",0),
(3,"2025-09-22",0),
(4,"2025-09-28",0);
   
insert into orderdetails(orderid,productid,quantity,subtotal) values
(1,1,6,6*499),
(1,5,1,1*2599),
(2,3,1,1*1299),
(3,4,2,2*899),
(4,2,1,1*9200);

SET SQL_SAFE_UPDATES = 0;

update orders o 
set totallamount =(  
	select ifnull(sum(od.subtotal),0)
    from orderdetails od
    where od.orderid=o.orderid
    );

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orderDetails;

-- 1
update customers
set address="b3,101,shantanu,surat"
where customerid=1;

 SELECT * FROM customers;
 
 delete from customers where customerid=5;
 
 SELECT * FROM Customers WHERE Name = 'Alice';
 
 -- 2
  SELECT * FROM orders;
  
 SELECT * FROM orders
WHERE orderdate >= CURDATE() - INTERVAL 30 DAY;

SELECT * FROM orders;

SELECT MAX(totallamount) AS HighestOrder,
MIN(totallamount) AS LowestOrder,
AVG(totallamount) AS AverageOrder
FROM orders;

delete from orders where orderid=5;

-- 3 

SELECT * FROM products;

SET SQL_SAFE_UPDATES = 0;

update products
set price=500 where productname="earbuds"; 

delete from products where stock=0;

select * from products where price between 500 and 2000;

select 
(select productname from products where price=(select max(price) from products))as product_name,
(select price from products where price=(select max(price) from products))as MostExpensive,
(select productname from products where price=(select min(price) from products))as product_name,
(select price from products where price=(select min(price) from products))as cheapest;

-- 4

select * from orderdetails;

select * from orderdetails where orderid=1;

select sum(subtotal) as total_revenue from orderdetails;

select p.productid,p.productname,sum(o.quantity) as totalsold 
from orderdetails o 
join products p on o.productid=p.productid
group by p.productid , p.productname
order by totalsold desc limit 3;

select p.productid,p.productname,sum(o.quantity) as totalsold 
from products p left join orderdetails o on p.productid = o.productid   
where p.productid=1
group by p.productid , p.productname;

