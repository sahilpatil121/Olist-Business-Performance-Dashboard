------------------------------------------------------------------------------------------------------------------
--DATA CLEANING...

--customer table
SELECT * FROM olist_customers_dataset;

-- changing short form state name to full form
SELECT DISTINCT customer_state FROM olist_customers_dataset;

 UPDATE olist_customers_dataset
 SET customer_state= CASE customer_state WHEN 'RS' THEN 'Rio Grande do Sul'
 WHEN 'SC' THEN 'Santa Catarina'
 WHEN 'DF' THEN 'Federal District'
 WHEN 'MG' THEN 'Minas Gerais'
 WHEN 'RN' THEN 'Rio Grande do Norte'
 WHEN 'SP' THEN 'Sao Paulo'
 WHEN 'GO' THEN 'Goias'
 WHEN 'AM' THEN 'Amazonas'
 WHEN 'PA' THEN 'Para' 
 WHEN 'PB' THEN 'Paraiba'
 WHEN 'PE' THEN 'Pernambuco'
 WHEN 'AP' THEN 'Amapa'
 WHEN 'ES' THEN 'Espirito Santo'
 WHEN 'TO' THEN 'Tocantins'
 WHEN 'MT' THEN 'Mato Grosso'
 WHEN 'RR' THEN 'Roraima'
 WHEN 'PI' THEN 'Piaui'
 WHEN 'PR' THEN 'Parana'
 WHEN 'CE' THEN 'Ceara'
 WHEN 'BA' THEN 'Bahia'
 WHEN 'AC' THEN 'Acre'
 WHEN 'RJ' THEN 'Rio de Janeiro'
 WHEN 'MA' THEN 'Maranhao'
 WHEN 'AL' THEN 'Alagoas'
 WHEN 'RO' THEN 'Rondonia'
 WHEN 'SE' THEN 'Sergipe'
ELSE 'Mato Grosso do Sul' END;

------------------------------------------------------------------------------------------------------------------

-- order payment tables

SELECT * FROM olist_order_payments_dataset;

-- replace underscore from payment type
UPDATE olist_order_payments_dataset
SET payment_type= REPLACE(payment_type,'_',' ')
WHERE payment_type IN('Credit_Card','Debit_Card');

-----------------------------------------------------------------------------------------------------------------
-- orders table

SELECT * FROM olist_orders_dataset;

-- checking for null value found order_delivery_carrier_date-1783 null,order_delivered_customer_date-2965 and order_approved_at-160 null

SELECT COUNT(*) FILTER(WHERE order_delivered_carrier_date IS NULL) AS carrier_date,
COUNT(*) FILTER(WHERE order_delivered_customer_date IS NULL) AS customer_date,
COUNT(*) FILTER(WHERE order_estimated_delivery_date IS NULL) AS est_dev_date,
COUNT(*) FILTER(WHERE order_purchase_timestamp IS NULL) AS purchase_date,
COUNT(*) FILTER(WHERE order_approved_at IS NULL) AS c_s FROM olist_orders_dataset;

--found 161 orders where order_purchase_timestamp occured after order_delivered_carrier_date...

SELECT order_purchase_timestamp,order_delivered_carrier_date,
order_purchase_timestamp- order_delivered_carrier_date AS order_diff 
FROM olist_orders_dataset
WHERE order_purchase_timestamp > order_delivered_carrier_date;

-- combining order_status

ALTER TABLE olist_orders_dataset
ADD Column order_status_updated VARCHAR(20);

UPDATE olist_orders_dataset
SET order_status_updated= CASE WHEN order_status='Canceled' THEN 'Cancelled'
 WHEN order_status='Unavailable' THEN 'Cancelled'
 WHEN order_status='Processing' THEN 'Active'
 WHEN order_status='Shipped' THEN 'Active'
 WHEN order_status='Invoiced' THEN 'Active'
 WHEN order_status='Created' THEN 'Active'
ELSE 'Delivered' END;
-----------------------------------------------------------------------------------------------------------------

--products table

SELECT * FROM olist_products_dataset;

-- changing product name to english
UPDATE olist_products_dataset p
SET product_category_name= pt.product_category_name_english
FROM product_category_name_translati pt
WHERE p.product_category_name=pt.product_category_name;

--handling null value 
UPDATE olist_products_dataset
SET product_category_name= COALESCE(product_category_name,'unknown');

-- removing underscore from category name
UPDATE olist_products_dataset
SET product_category_name=REPLACE(product_category_name,'_',' ');

-- Capitalizing first name of category

UPDATE olist_products_dataset
SET product_category_name=INITCAP(product_category_name)

----------------------------------------------------------------------------------------------------------------

--sellers table

SELECT * FROM olist_sellers_dataset;

select distinct seller_city from olist_sellers_dataset;

-- cleaning seller city 

UPDATE olist_sellers_dataset
SET seller_city=split_part(seller_city,'-',1)
WHERE seller_city like '%-%';

UPDATE olist_sellers_dataset
SET seller_city=split_part(seller_city,',',1)
WHERE seller_city like '%,%';

-- updating seller state to full form

UPDATE olist_sellers_dataset
 SET seller_state= CASE seller_state WHEN 'RS' THEN 'Rio Grande do Sul'
 WHEN 'SC' THEN 'Santa Catarina'
 WHEN 'DF' THEN 'Federal District'
 WHEN 'MG' THEN 'Minas Gerais'
 WHEN 'RN' THEN 'Rio Grande do Norte'
 WHEN 'SP' THEN 'Sao Paulo'
 WHEN 'GO' THEN 'Goias'
 WHEN 'AM' THEN 'Amazonas'
 WHEN 'PA' THEN 'Para'
 WHEN 'PB' THEN 'Paraiba'
 WHEN 'PE' THEN 'Pernambuco'
 WHEN 'ES' THEN 'Espirito Santo'
 WHEN 'MT' THEN 'Mato Grosso'
 WHEN 'PI' THEN 'Piaui'
 WHEN 'PR' THEN 'Parana'
 WHEN 'CE' THEN 'Ceara'
 WHEN 'BA' THEN 'Bahia'
 WHEN 'AC' THEN 'Acre'
 WHEN 'RJ' THEN 'Rio de Janeiro'
 WHEN 'MA' THEN 'Maranhao'
 WHEN 'RO' THEN 'Rondonia'
 WHEN 'SE' THEN 'Sergipe'
ELSE 'Mato Grosso do Sul' END;
