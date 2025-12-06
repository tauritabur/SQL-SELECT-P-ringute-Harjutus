-- 1) TOP 10 klienti, kellel on kõige suurem kogukäive
-- Eesmärk: Admin näeb, kes on kõige väärtuslikumad kliendid
-- Oodatav tulemus: 10 klienti koos nende tellimuste arvuga ja kulutatud summaga
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

-- 2) Kõige populaarsemad tooted (sagedus order_items tabelis)
-- Eesmärk: Admin näeb, millised tooted müüvad kõige rohkem
-- Oodatav tulemus: TOP 10 toodet koos müüdud kogusega
SELECT 
    p.id,
    p.name,
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_sold DESC
LIMIT 10;

-- 3) Tellimused üle 500€ koos kliendi kontaktiga (email)
-- Eesmärk: Admin saab kõrge väärtusega tellimuste puhul kliendiga ühendust võtta
-- Oodatav tulemus: Kõik tellimused >500€ koos tellimuse kuupäeva, summa, kliendi nime ja e-mailiga
SELECT 
    o.id AS order_id,
    o.order_date,
    o.total_amount,
    c.first_name,
    c.last_name,
    c.email
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.total_amount > 500
ORDER BY o.total_amount DESC;

-- 4) Tootekategooriate lõikes müügi kogusummad
-- Eesmärk: Admin näeb, millised kategooriad toovad kõige rohkem tulu
-- Oodatav tulemus: Iga kategooria müügi kogusumma
SELECT 
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.category
ORDER BY total_sales DESC;

-- 5) Kliendid, kellel on rohkem kui 5 tellimust (aktiivsed kliendid)
-- Eesmärk: Admin näeb aktiivseid kliente, kellele võib pakkuda kampaaniaid
-- Oodatav tulemus: Kõik kliendid, kelle tellimuste arv >5
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

-- 6) Päevane müük viimase kuu jooksul
-- Eesmärk: Admin saab jälgida päevast käivet
-- Oodatav tulemus: Iga päeva tellimuste arv ja kogusumma viimase kuu jooksul
SELECT 
    DATE(o.order_date) AS day,
    COUNT(o.id) AS orders_count,
    SUM(o.total_amount) AS total_revenue
FROM orders o
WHERE o.order_date >= NOW() - INTERVAL '30 days'
GROUP BY DATE(o.order_date)
ORDER BY day DESC;

-- 7) TOP 10 klienti koos ostetud toodete koguarvuga (3+ tabeli JOIN näide)
-- Eesmärk: Näitab väärtuslikumaid kliente ja kui palju tooteid nad kokku ostsid
-- Oodatav tulemus: TOP 10 klienti koos ostetud toodete koguarvuga
SELECT 
    c.id,
    c.first_name,
    c.last_name,
    COUNT(oi.id) AS total_items
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_items DESC
LIMIT 10;
