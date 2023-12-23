CREATE TABLE distributor(
	id SERIAL PRIMARY KEY,
	name  VARCHAR (100)
);

INSERT INTO distributor (name) VALUES
('Parawholesale'),
('J & B Sales'),
('Steel City Clothing');

SELECT * FROM distributor;

CREATE TABLE distributor_audit(
	id SERIAL PRIMARY KEY, 
	dist_id INT NOT NULL,  
	name VARCHAR(100) NOT NULL, 
	edit_date TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION fn_plsql_log_dist_name_change()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$body$
BEGIN
	IF NEW.name <> OLD.name THEN
		INSERT INTO  distributor_audit
		(dist_id, name, edit_date)
		VALUES
		(OLD.id, OLD.name, NOW());
	END IF;
	RAISE NOTICE 'Trigger Name %', TG_NAME;
	RAISE NOTICE 'Table Name %', TG_TABLE_NAME;
	RAISE NOTICE 'Operation %', TG_OP;
	RAISE NOTICE 'When executed %', TG_WHEN;
	RAISE NOTICE 'Row or Statement %', TG_LEVEL;
	RAISE NOTICE 'Table Schema %', TG_TABLE_SCHEMA;
	RETURN NEW;
END;
$body$

CREATE TRIGGER tr_dist_name_changed
	BEFORE UPDATE 
	ON distributor
	FOR EACH ROW
	EXECUTE PROCEDURE fn_plsql_log_dist_name_change();

UPDATE distributor SET name = 'Western Clothing' WHERE id = 2;

select * from distributor_audit;