CREATE OR REPLACE FUNCTION fn_psql_get_item_price(prod_name varchar)
RETURNS numeric AS
$body$
BEGIN
	RETURN item.price FROM item
	NATURAL JOIN product
	WHERE product.name = 'Grandview';	
END
$body$
LANGUAGE plpgsql;

select fn_psql_get_item_price('Grandview');

---

CREATE OR REPLACE FUNCTION fn_psql_sum(var1 int, var2 int)
RETURNS int AS
$body$
DECLARE
	ans int;
BEGIN
	ans := var1 + var2;
	RETURN ans;
END
$body$
LANGUAGE plpgsql;

select fn_psql_sum(4,6);

---
CREATE OR REPLACE FUNCTION fn_psql_get_rand(min_val int, max_val int)
RETURNS int AS
$body$
DECLARE
	rand int;
BEGIN
	select random()*(max_val - min_val) + min_val into rand;
	RETURN rand;
END
$body$
LANGUAGE plpgsql;

select fn_psql_get_rand(1,50);

---

CREATE OR REPLACE FUNCTION fn_psql_get_random_sales_person()
RETURNS varchar AS
$body$
DECLARE
	rand int;
	emp record;
BEGIN
	select random()*(5 - 1) + 1 into rand;
	select * from sales_person into emp where id = rand;
	RETURN concat(emp.first_name,' ', emp.last_name);
END
$body$
LANGUAGE plpgsql;

select fn_psql_get_random_sales_person();

---

CREATE OR REPLACE FUNCTION fn_psql_sum_of_two(IN var1 int, IN var2 int, OUT var3 int)
AS
$body$
BEGIN
	var3 := var1 + var2;
END
$body$
LANGUAGE plpgsql;

select fn_psql_sum_of_two(1,10);

---
CREATE OR REPLACE FUNCTION fn_psql_get_customer_birth(in the_month int , out bd_day int , out bd_month int , out f_name varchar, out l_name varchar)
AS
$body$
BEGIN
	select extract(MONTH from birth_date), extract(DAY FROM birth_date), first_name, last_name 
	into bd_month, bd_day, f_name, l_name 
	from customer
	where extract(MONTH from birth_date) = the_month
	limit 1;
END
$body$
LANGUAGE plpgsql
select fn_psql_get_customer_birth(12)

---

CREATE OR REPLACE FUNCTION fn_plsql_get_sales_people()
RETURNS SETOF sales_person AS
$body$
BEGIN
	RETURN QUERY
	select * from sales_person;
END
$body$
LANGUAGE plpgsql;

SELECT (fn_plsql_get_sales_people()).first_name;

---

CREATE OR REPLACE FUNCTION fn_plsql_get_top_ten_price()
RETURNS TABLE (name varchar, supplier varchar, price numeric) AS
$body$
BEGIN
	RETURN QUERY
	SELECT product.name, product.supplier, item.price from item 
	NATURAL JOIN product
	order by item.price desc LIMIT 10;
END
$body$
LANGUAGE plpgsql;

SELECT (fn_plsql_get_top_ten_price()).*;

---

CREATE OR REPLACE FUNCTION fn_plsql_get_total_of_order_by_month(the_month int)
RETURNS varchar AS
$body$
DECLARE
	total_orders int;
BEGIN
	SELECT COUNT(*)
	INTO total_orders
	FROM sales_order 
	WHERE EXTRACT(MONTH FROM time_order_taken) = the_month;
	IF	total_orders > 5 THEN
		RETURN CONCAT(total_orders, ' Doing good');
	ELSEIF total_orders < 5 THEN
		RETURN CONCAT(total_orders, ' Doing bad');
	ELSE
		RETURN CONCAT(total_orders, ' Orders on target');
	END IF;
END
$body$
LANGUAGE plpgsql;

SELECT fn_plsql_get_total_of_order_by_month(11);

---
CREATE OR REPLACE FUNCTION fn_plsql_check_month_orders(the_month int)
RETURNS varchar AS
$body$
DECLARE
	total_orders int;
BEGIN
	SELECT COUNT(*)
	INTO total_orders
	FROM sales_order 
	WHERE EXTRACT(MONTH FROM time_order_taken) = the_month;
	CASE
		WHEN total_orders < 1 THEN
			RETURN CONCAT(total_orders, ' Orders: Terrible!');
		WHEN total_orders > 1 AND total_orders < 5 THEN
			RETURN CONCAT(total_orders, ' Orders on Target!');
		ELSE
			RETURN CONCAT(total_orders, ' Orders: Doing good!');
	END CASE;
END
$body$
LANGUAGE plpgsql;

SELECT fn_plsql_check_month_orders(12);

---

CREATE OR REPLACE FUNCTION fn_psql_loop_test(max_num int)
RETURNS int AS
$body$
DECLARE
	j int DEFAULT 1;
	tot_sum int DEFAULT 0;
BEGIN
	LOOP
		tot_sum := tot_sum + j;
		j := j + 1;
		EXIT WHEN j > max_num;
	END LOOP;
	RETURN  tot_sum;
END
$body$
LANGUAGE plpgsql;

SELECT fn_psql_loop_test(5);

CREATE OR REPLACE FUNCTION fn_psql_for_test(max_num int)
RETURNS int AS
$body$
DECLARE
	tot_sum int DEFAULT 0;
BEGIN
	FOR  i IN 1 .. max_num BY 2
	LOOP
		tot_sum := tot_sum + i;
	END LOOP;
	RETURN  tot_sum;
END
$body$
LANGUAGE plpgsql;

SELECT fn_psql_for_test(5);

---

CREATE OR REPLACE FUNCTION fn_psql_reverse_for_test(max_num int)
RETURNS int AS
$body$
DECLARE
	tot_sum int DEFAULT 0;
BEGIN
	FOR  i IN REVERSE max_num .. 1 BY 2
	LOOP
		tot_sum := tot_sum + i;
	END LOOP;
	RETURN  tot_sum;
END
$body$
LANGUAGE plpgsql;

SELECT fn_psql_reverse_for_test(5);

---

DO
$body$
DECLARE
	rec record;
BEGIN
	FOR rec IN SELECT first_name, last_name FROM sales_person LIMIT 5
	LOOP
		RAISE NOTICE '% %', rec.first_name, rec.last_name;
	END LOOP;
END
$body$
LANGUAGE plpgsql

---

DO
$body$
DECLARE
	j int DEFAULT 0;
	t_sum int DEFAULT 0;
BEGIN
	WHILE j <= 10
	LOOP
		t_sum := t_sum + j;
		j := j + 1;
	END LOOP;
	RAISE NOTICE '%', t_sum;
END
$body$
LANGUAGE plpgsql

---

DO
$body$
DECLARE
	arr1 int[] := array[1,2,3];
	i int;
BEGIN
	FOREACH i IN ARRAY arr1
	LOOP
		RAISE NOTICE '%', i;
	END LOOP;
END
$body$
LANGUAGE plpgsql

---

DO
$body$
	DECLARE
		i INT DEFAULT 0;
	BEGIN
		LOOP
			i := i + 1;
			EXIT WHEN i > 10;
			CONTINUE WHEN MOD(i, 2) = 0;
			RAISE NOTICE 'Num : %', i;
		END LOOP;
	END;
$body$
LANGUAGE plpgsql

---
CREATE OR REPLACE FUNCTION fn_plsql_get_supplier_value(the_supplier varchar)
RETURNS varchar AS
$body$
DECLARE
	supplier_name varchar;
	price_sum numeric;
BEGIN
	SELECT product.supplier, SUM(item.price) INTO supplier_name, price_sum
	FROM product, item WHERE product.supplier = the_supplier GROUP BY product.supplier;
	RETURN CONCAT(supplier_name, ' Inventory Value : $', price_sum);
END
$body$
LANGUAGE plpgsql;

SELECT fn_plsql_get_supplier_value('Nike');