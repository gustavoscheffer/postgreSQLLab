DO
$body$
DECLARE
    msg text DEFAULT '';
    rec_customer record;
    cur_customers CURSOR
    FOR
        SELECT * FROM customer;
    BEGIN
        OPEN cur_customers;
        LOOP
            FETCH cur_customers INTO rec_customer;
            EXIT WHEN NOT FOUND;
            msg := msg || rec_customer.first_name || ' ' || rec_customer.last_name || ', ' ;
        END LOOP;
        RAISE NOTICE 'Customers: %', msg;
    END;
$body$

---

CREATE OR REPLACE FUNCTION fn_plsql_get_cust_by_state(c_state VARCHAR)
RETURNS text
LANGUAGE PLPGSQL
AS
$body$
DECLARE
    cust_name TEXT DEFAULT '';
    rec_customer RECORD;
    cur_cust_by_state CURSOR (c_state varchar)
FOR 
	SELECT first_name, last_name, state FROM customer WHERE state = c_state;
BEGIN
	OPEN cur_cust_by_state(c_state);
	LOOP
		FETCH cur_cust_by_state INTO rec_customer;
		EXIT WHEN NOT FOUND;
		cust_name := cust_name || rec_customer.first_name || ' ' || rec_customer.last_name || ', '; 
	END LOOP;
	CLOSE  cur_cust_by_state;
	RETURN cust_name;
END;
$body$

SELECT fn_plsql_get_cust_by_state('CA');