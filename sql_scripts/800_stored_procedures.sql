CREATE TABLE public.past_due (
	id SERIAL PRIMARY KEY,
	cust_id INTEGER NOT NULL,
	balance NUMERIC(6,2) NOT NULL
);

INSERT INTO past_due(cust_id, balance)
VALUES
(1,123.45),
(2,324.50);

SELECT * FROM past_due;

CREATE OR REPLACE PROCEDURE  pr_debt_paid(past_due_id int, payment numeric)
AS
$body$
DECLARE
BEGIN
	UPDATE past_due
	SET balance = balance - payment
	WHERE id = past_due_id;
	COMMIT;
END
$body$
LANGUAGE PLPGSQL;

CALL pr_debt_paid(1,10.00);

SELECT * FROM past_due;