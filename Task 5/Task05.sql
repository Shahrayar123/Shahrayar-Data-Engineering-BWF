-- Task 05

-- 1). Write a query to calculate the percentage contribution of each
-- item's amount to its order's total amount, grouped by order_id.
-- 	(Topics: Partition BY)

SELECT items.order_id,
	items.item_id,
	items.amount,
	(items.amount / SUM(items.amount) OVER (PARTITION BY items.order_id)) * 100  AS "% contribution"
	FROM task4_schema.items AS items
LEFT JOIN task4_schema.orders AS orders 
	ON items.order_id = orders.order_id
ORDER BY 
	items.order_id,
	items.item_id

	

-- 2). Write a query to rank orders by their total amount within
-- each customer, ordering them from highest to lowest total amount.
-- 	(Topics: Window functions like RANK, PARTITION BY, and ORDER BY)

SELECT customers.customer_id,
	orders.order_id,
	orders.total_amount,
	RANK() OVER (PARTITION BY customers.customer_id ORDER BY orders.total_amount DESC) AS order_rank
	FROM task4_schema.orders AS orders 
	LEFT JOIN task4_schema.customers AS customers  
	ON orders.customer_id = customers.customer_id
ORDER BY 3 DESC

	

-- 3). Write a query to calculate the average price of products supplied
-- by each supplier. Exclude suppliers who have no products in the result.
-- 	(Topics: JOINS, AGGREGATE FUNCTIONS, GROUP BY)

SELECT 
	suppliers.supplier_id,
	suppliers.name,
	AVG(products.price) AS "Average Price"	
FROM task4_schema.products 
LEFT JOIN task4_schema.suppliers
ON products.supplier_id = suppliers.supplier_id
GROUP BY suppliers.supplier_id
HAVING COUNT(products.price) != 0


	
-- 4). Write a query to count the number of products in each category.
-- Include categories with zero products in the result set.
-- 	(WINDOW FUNCTIONS, AGGREGATE FUNCTIONS, JOINS, GROUP BY)

SELECT products.category,
	count(products.category)
	FROM task4_schema.products
GROUP BY products.category
HAVING count(products.category) = 0


	
-- 5). Write a query to retrieve the total amount spent by each
-- customer, along with their name and phone number. Ensure customers
-- 	with no orders also appear with a total amount of 0.
-- 	(WINDOW FUNCTIONS, AGGREGATE FUNCTIONS, JOINS, GROUP BY)

SELECT 
	customers.customer_id,
	customers.name,
	customers.phone,
	COALESCE(SUM(orders.total_amount), 0) AS "Total Amount"
FROM task4_schema.customers
LEFT JOIN task4_schema.orders 
ON customers.customer_id = orders.customer_id
GROUP BY 1

