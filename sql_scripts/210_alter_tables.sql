ALTER TABLE customer ALTER COLUMN zip TYPE INTEGER;

ALTER TABLE sales_person ALTER COLUMN zip TYPE INTEGER;

ALTER TABLE sales_item ADD day_of_week VARCHAR(8);

ALTER TABLE sales_item  ALTER COLUMN day_of_week SET NOT NULL;

ALTER TABLE sales_item  RENAME COLUMN day_of_week TO weekday;

ALTER TABLE sales_item  DROP COLUMN weekday;

ALTER TABLE customer ALTER COLUMN sex TYPE sex_type USING sex::sex_type;

ALTER TABLE sales_order ALTER COLUMN purchase_order_number TYPE BIGINT;