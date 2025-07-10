--Library Management system Project 2
--creating a branch table
drop table if exists branch;
create table branch
(
branch_id	varchar(10) primary key ,
manager_id varchar(10),
branch_address varchar(55),
contact_no  varchar(10));
alter table branch
alter column contact_no type varchar(15)

drop table if exists employees
create table employees
(
emp_id varchar(10) primary key,
emp_name	varchar(16),
position	varchar(15),
salary int,
branch_id varchar(25));--FK

drop table  if exists books;
create table books
(
isbn varchar(20) primary key,
book_title varchar(75),
category varchar(25),
rental_price Float,
status	varchar(15),
author varchar(35),	
publisher varchar(55)
);
alter table  books
alter column category type varchar(20);


DROP TABLE IF EXISTS members;
create table members(
member_id varchar(20) Primary key,
member_name	varchar(25),
member_address	varchar(75),
reg_date DATE
);


drop table if exists issued_status
create table issued_status
(
issued_id varchar(10) primary key,
issued_member_id varchar(10),--FK
issued_book_name varchar(75),
issued_date	date,
issued_book_isbn varchar(25), --FK
issued_emp_id varchar(10) --FK
);



drop table if exists return_status
create table return_status
(return_id varchar(10) primary key,
issued_id varchar(10),
return_book_name varchar(75),
return_date Date ,
return_book_isbn varchar(20));


ALTER TABLE members
ADD CONSTRAINT pk_member_id PRIMARY KEY (member_id);
--foreign key
alter table issued_status
add constraint fk_members
foreign key(issued_member_id)
references members(member_id);

ALTER TABLE issued_status
ADD COLUMN issued_books_isbn VARCHAR(20);

alter table issued_status
add constraint fk_books
foreign key(issued_books_isbn)
references books(isbn);


alter table issued_status
add constraint fk_employees
foreign key(issued_emp_id)
references employees(emp_id);

alter table employees
add constraint fk_branch
foreign key(branch_id)
references branch(branch_id);

alter table return_status
add constraint fk_issued_status
foreign key(issued_id)
references issued_status(issued_id);

