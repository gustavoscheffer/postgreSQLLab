-- Comments

/*
Multiline comments
*/

-- > Return all fields when the discount is greater than 15%
select * from sales_item where discount > .15;

-- > Return time_order_taken, customer_id from sales_order when time_order is between 2018-12-01 and 2018-12-31
select time_order_taken, customer_id from sales_order where time_order_taken > '2018-12-01' and time_order_taken < '2018-12-31';

-- > Return the top five when the discount is greater than 15% ordered descendantly.
select * from sales_item where discount > .15 order by discount desc limit 5;

-- > Return first and last name as full name + phone and state when customer state is Texas
select concat(first_name,' ', last_name) as name, phone, state from customer where state = 'TX'

-- > Return the product id and the sum of all products as total when the product id is equal to 1
select product_id, sum(price) as Total from item where product_id = 1 group by product_id

-- > Return the customer's state removing duplicated states
select distinct state from customer order by state

-- > Return the state when differs from CA. Remove duplicates as well.
select distinct state from customer where state != 'CA' order by state desc;

-- > Return the state when differs from CA. Remove duplicates as well.
select distinct state from customer where state <> 'CA' order by state desc;

-- > Return all customers with IL or TX as the state in ascendant order.
select * from customer where state in ('IL', 'TX') order by state asc;

-- > Return item ID, price and discount from a join between item and sales..
select item_id, price, discount from item inner join sales_item on item.id = sales_item.item_id order by item_id;

-- > Return sales_order ID, sales_order quantity, item price, and total from a join between sales order, sales item, and item.
select sales_order.id, sales_item.quantity, item.price, (sales_item.quantity * item.price) as Total from sales_order join sales_item on sales_item.sales_order_id = sales_order.id join item on item.id = sales_item.item_id

-- > Return product data and item price even if product has not item data 
select product.name, product.supplier, item.price from product left join item on item.product_id = product.id order by product.name;

-- > Return sales_order_id, quantity, product_id from item joined to sales_id
select sales_order_id, quantity, product_id from item cross join sales_item order by sales_order_id;

-- > Return customer and sales person data when birth_date's month is 12.
select first_name, last_name, street, city, zip, birth_date from customer where extract(month from birth_date) = 12 union select first_name, last_name, street, city, zip, birth_date from sales_person where extract(month from birth_date) = 12 

-- > select product id and price when price is not null
select product_id, price from item where price is not null;

-- > Return first and last name when first name start with M
select first_name, last_name from customer where first_name similar to 'M%';

-- > Return first and last name when name start with A and has 5 carachers after.
select first_name, last_name from customer where first_name like 'A_____';

-- > Return first and last name from customer where first name start with D or last name ends with n
select first_name, last_name from customer where first_name similar to 'D%' or last_name similar to '%n';

-- > Return first and last name from customer where last_name ends with ez or som (using regex)
select first_name, last_name from customer where last_name ~ 'ez$|son$';

-- > Return first and last name from customer where last_name has letters from w up to z.
select first_name, last_name from customer where last_name ~ '[w-z]';

-- > Return the total of customers per month ordered by month
select extract (month from birth_date) as Month, count(*) as Amount from customer group by Month order by Month;

-- > Return the total of customers per month ordered by month if the month has more than one customer
select extract (month from birth_date) as Month, count(*) as Amount from customer group by Month having count(*) > 1  order by Month;

-- > Return the sum of all prices
select sum (price) as SumOfPrice from item;

-- > Return the total of items, sum of prices, max price, min price and the average from item
select count(*) as Items, SUM(price) as Total, MIN(price) as Min, MAX(price) as Max, ROUND(AVG(price),2) as Avg from item ;