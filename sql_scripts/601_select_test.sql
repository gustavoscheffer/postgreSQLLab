-- Top three sales person 2017

select name, sum(total) as total_person
	from (
		select 
			sales_item.sales_order_id as order_id, 
			concat(sales_person.first_name,' ', sales_person.last_name) as name,
			((item.price * sales_item.quantity)- sales_item.discount) as total 
		from sales_item
			join item on item.id = sales_item.item_id
			join sales_order on sales_order.id = sales_item.sales_order_id
			join sales_person on sales_person.id = sales_order.sales_person_id
			where extract (year from sales_order.time_order_taken) = 2017
		)
group by name
order by total_person desc
limit 3