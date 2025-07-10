select* from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;
select * from members;
. Create a Table of Books with Rental Price Above a Certain Threshold:

--question
--Task 1. Create a New Book Record -- '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

--Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table;
select * from  issued_status;
delete from issued_status
where issued_id='IS121'


--Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'


--Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id,count(issued_id) as total_book_issued
from issued_status
group by issued_emp_id
having count(issued_id)>1



--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**
 create table books_cnts as select b.isbn,book_title, count(ist.issued_id) as no_issued 
 from books as b 
 join 
 issued_status as ist
 on ist.issued_book_isbn=b.isbn
 group by 1,2;
 select * from books _cnts


--Task 7: Retrieve All Books in a Specific Category:
select * from books where category='Classic';

--Task 8: Find Total Rental Income by Category:
select b.category,
sum(b.rental_price),
count(*)
 from books as b 
 join 
 issued_status as ist
 on ist.issued_book_isbn=b.isbn
 group by 1;

 --Task 9: List Members Who Registered in the Last 180 Days:
select * from members
where reg_date >= current_date  - interval '180 days';
insert into members(member_id,member_name,member_address,reg_date)
values('C120','Sam','145 Main St','2024-06-01'),
('C113','John','123 Main St','2024-05-01');



--Task 10:List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id


--Task 11:. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;


--Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;


__ advance  sql tasks queary;
__ advance  sql tasks queary;
__ advance  sql tasks queary;
__ advance  sql tasks queary;
__ advance  sql tasks queary;


select* from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.*/

-- issued_status == members==books===return_status
-- filter books which is return
-- overdue>30
select current_date;
select ist.issued_member_id,
m.member_name,
bk.book_title,
ist.issued_date,
rs.return_date,
CURRENT_DATE - ist.issued_date as over_dues
from 
issued_status as ist
join 
members as m
 on m.member_id = ist.issued_member_id
 join
 books as bk
 on bk.isbn=ist.issued_book_isbn
left join 
return_status as rs
on rs.issued_id = ist.issued_id
where rs.return_date  is null and 
(CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1


/*Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table). */
select * from issued_status;

select * from books where isbn='978-0-451-52994-2';

select * from issued_status where issued_book_isbn ='978-0-451-52994-2';

update books
set status='no'
where isbn='978-0-451-52994-2';

select * from return_status
 WHERE issued_id = 'IS130'

 CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR(10), 
    p_issued_id VARCHAR(10), 
    p_book_quality VARCHAR(10)
)
LANGUAGE plpgsql
AS 
$$
DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
BEGIN
    -- Insert a return record
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    -- Get book details from issued_status
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update status in books table
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Confirmation message
    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
END;
$$;


/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of
 books issued, the number of books returned, and the total revenue generated from book rentals.*/

CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;
SELECT * FROM branch_reports;

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing 
members who have issued at least one book in the last 2 months.*/
CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
DISTINCT issued_member_id   
FROM issued_status
WHERE 
issued_date >= CURRENT_DATE - INTERVAL '2 month');
SELECT * FROM active_members;

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.*/
SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2



 