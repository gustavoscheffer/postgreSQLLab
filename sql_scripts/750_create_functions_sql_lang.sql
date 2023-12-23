CREATE OR REPLACE FUNCTION public.fn_add_ints(INT, INT) RETURNS INT AS
$body$
	SELECT $1 + $2;
$body$
LANGUAGE SQL

SELECT fn_add_ints(5,4);

--
CREATE OR REPLACE FUNCTION public.fn_update_employee_state() 
RETURNS void AS
$body$
	UPDATE public.sales_person SET state = 'PA' WHERE state is null;
$body$
LANGUAGE SQL;

SELECT fn_update_employee_state();

--
CREATE OR REPLACE FUNCTION public.fn_get_max_product_price()
RETURNS NUMERIC as
$body$
	SELECT MAX(price) FROM item;
$body$
LANGUAGE SQL

SELECT fn_get_max_product_price();

--

CREATE OR REPLACE FUNCTION public.fn_get_value_inventory()
RETURNS NUMERIC as
$body$
	SELECT SUM(price) FROM item;
$body$
LANGUAGE SQL

SELECT fn_get_value_inventory();

---

CREATE OR REPLACE FUNCTION public.fn_get_total_customers()
RETURNS INT AS
$body$
	SELECT COUNT(*) FROM customer;
$body$
LANGUAGE SQL;

SELECT public.fn_get_total_customers();

---

CREATE OR REPLACE FUNCTION public.fn_get_customers_without_phone()
RETURNS numeric AS
$body$
	SELECT COUNT(*) FROM customer WHERE phone is null;
$body$
LANGUAGE SQL;

SELECT public.fn_get_customers_without_phone();

---

CREATE OR REPLACE FUNCTION public.fn_get_total_customers_from_state(state_name char(2))
RETURNS numeric AS
$body$
	SELECT COUNT(*) FROM customer WHERE state = state_name;
$body$
LANGUAGE SQL;

SELECT public.fn_get_total_customers_from_state();

---

CREATE OR REPLACE FUNCTION fn_get_total_orders_from_customer(cus_fname varchar, cus_lname varchar)
RETURNS numeric AS
$body$
	SELECT COUNT(*) FROM sales_order
	NATURAL JOIN customer 
	WHERE first_name = 'Christopher' AND last_name = 'Jones';	
$body$
LANGUAGE SQL;

select public.fn_get_total_orders_from_customer('Christopher','Jones');

---

CREATE OR REPLACE FUNCTION fn_get_last_order()
RETURNS sales_order AS
$body$
	SELECT * FROM sales_order 
	ORDER BY time_order_taken 
	DESC LIMIT 1;
$body$
LANGUAGE SQL;

select (public.fn_get_last_order()).*;

select to_json(public.fn_get_last_order());

---

CREATE OR REPLACE FUNCTION fn_get_sales_person_location(loc varchar)
RETURNS SETOF sales_person AS
$body$
	SELECT * FROM sales_person WHERE state = loc;
$body$
LANGUAGE SQL;

select first_name, last_name, email, city, state FROM fn_get_sales_person_location('CA') ORDER BY first_name asc;

---

/* list all functions created by me now */
select * from information_schema.routines where routine_type = 'FUNCTION' AND routine_name LIKE 'fn_%'

/* delete specific function */
DROP FUNCTION fn_get_total_customers;