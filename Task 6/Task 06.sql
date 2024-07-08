-- Task 06

-- USE THE SAME DATABASE:

-- 1. Write a query to retrieve all orders placed by customers, 
-- 	including customer details (name, phone), order details 
-- 	(order ID, timestamp), and item details (product, amount). 


SELECT customers.name AS "Customer Name",
	customers.phone, 
	orders.order_id,
	orders.order_timestamp,
	products.name AS "Product Name",
	products.price
	FROM task4_schema.customers
LEFT JOIN task4_schema.orders ON customers.customer_id = orders.customer_id
LEFT JOIN task4_schema.items ON orders.order_id = items.order_id
LEFT JOIN task4_schema.products ON items.product_id = products.product_id

	

-- 2. Write a query to fetch all products along with their 
-- suppliers' details (name, phone) and the corresponding category name.

SELECT products.name AS "Product Name",
	suppliers.name AS "Supplier Name",
	suppliers.phone AS "Supplier Contact",
	suppliers.category AS "Supplier Category"
FROM task4_schema.products
LEFT JOIN task4_schema.suppliers 
	ON products.supplier_id = suppliers.supplier_id

	
-- 3. Write a query to retrieve details of all orders including 
-- the product name and amount ordered for each item.

SELECT orders.*,
	products.name AS "Product Name",
	items.amount AS "Item Amount"
FROM task4_schema.orders
LEFT JOIN task4_schema.items ON orders.order_id = items.order_id
LEFT JOIN task4_schema.products ON items.product_id = products.product_id


-- 4. Write a query to retrieve all suppliers along with the city 
-- and country where they are located, and the products they supply.

SELECT 
	suppliers.supplier_id,
	suppliers.name AS "Supplier Name",
	suppliers.location AS "Location",
    products.name AS "Product Name"	
	FROM task4_schema.suppliers
LEFT JOIN task4_schema.products ON suppliers.supplier_id = products.supplier_id


-- LEFT JOIN task4_schema.cities ON suppliers.location = cities.country
-- SELECT * FROM task4_schema.cities 


-- 5. Write a query to fetch details of the most recent order 
-- (by timestamp) placed by each customer, including the product
-- details for each item in the order. [This question will use a
-- 	Window Function alongside Joins]

SELECT * FROM 
	(SELECT 
	customers.customer_id,
	orders.order_id,
	orders.order_timestamp,
	ROW_NUMBER() OVER (PARTITION BY customers.customer_id ORDER BY orders.order_timestamp DESC) AS row_num
FROM task4_schema.orders
LEFT JOIN task4_schema.customers ON orders.customer_id = customers.customer_id
LEFT JOIN task4_schema.items ON orders.order_id = items.order_id
) Main
WHERE row_num = 1
	