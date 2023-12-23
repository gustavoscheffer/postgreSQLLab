CREATE OR REPLACE FUNCTION fn_plsql_block_weekend_changes()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$body$
BEGIN
	RAISE NOTICE 'No database changes allowed on the weekend';
	RETURN NULL;
END;
$body$

CREATE TRIGGER tr_block_weekend_changes
	BEFORE UPDATE OR INSERT OR DELETE OR TRUNCATE
	ON distributor
	FOR EACH STATEMENT
	WHEN (
		EXTRACT ('DOW' FROM CURRENT_TIMESTAMP) BETWEEN 6 AND 7
	)
	EXECUTE PROCEDURE fn_plsql_block_weekend_changes();

UPDATE distributor SET name = 'Western Clothing' WHERE id = 2;

select * from distributor_audit;

DROP FUNCTION fn_plsql_block_weekend_changes CASCADE;