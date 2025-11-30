-- 1) Leia TOP 10 klienti, kellel on kõige suurem kogukäive
SELECT 
    c.id,
    c.first_name,
    c.last_name,
    COUNT(o.id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;


-- 2) Leia kõige populaarsemad tooted (sagedus order_items tabelis)
SELECT 
    p.id,
    p.name,
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_sold DESC
LIMIT 10;


-- 3) Leia tellimused, mille kogusumma on üle 500€ (admini jaoks kasulik)
SELECT 
    o.id AS order_id,
    o.order_date,
    o.total_amount,
    c.first_name,
    c.last_name
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.total_amount > 500
ORDER BY o.total_amount DESC;


-- 4) Leia tootekategooriate lõikes müügi kogusummad
SELECT 
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.category
ORDER BY total_sales DESC;


-- 5) Leia kliendid, kellel on rohkem kui 5 tellimust (aktiivsed kliendid)
SELECT 
    c.id,
    c.first_name,
    c.last_name,
    COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.first_name, c.last_name
HAVING COUNT(o.id) > 5
ORDER BY order_count DESC;


-- 6) Leia iga päeva müük (päevane käive)
SELECT 
    DATE(o.order_date) AS day,
    COUNT(o.id) AS orders_count,
    SUM(o.total_amount) AS total_revenue
FROM orders o
GROUP BY DATE(o.order_date)
ORDER BY day DESC;
