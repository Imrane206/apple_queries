USE apple;
#import&Export the data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/apple_products.csv' INTO TABLE apple_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

#average of apple products rating 
select AVG(star_rating) as average_rating
from apple_sales


#calculating sales amount 
select ROUND(SUM(Sale_Price)/1000000, 2) as total_amount_in_million
from apple_sales


#number of products 
select count(distinct(product_name)) as num_products
from apple_sales

#top 10 ranking products that have the most number of reviews
select* from 
(select Product_name, Number_Of_Reviews,
DENSE_RANK() OVER(ORDER BY Number_Of_Reviews DESC) AS rnk
from apple_sales
order by  Number_Of_Reviews desc) as t1
where rnk<=10 ;



#top 10 ranking products that have the most number of rating 
select* from 
(select Product_name, Number_Of_Ratings,
DENSE_RANK() OVER(ORDER BY Number_Of_Ratings DESC) AS Rnk
from apple_sales
order by  Number_Of_Ratings desc) as t2
where rnk<=10 ;

#categorize the products depending of discount percentage

WITH reached_products_by_custmer AS (select 
Product_name,
Number_Of_Reviews,
Sale_Price,
Discount_Percentage,
CASE WHEN Discount_Percentage>15 then 'nice_discount'
     WHEN Discount_Percentage BETWEEN 10 AND 15 THEN 'DISCOUNTED'
     ELSE 'LOW_DISCOUNT'
END AS Discount_categorie,
DENSE_RANK() OVER(ORDER BY Number_Of_Reviews DESC) AS top_reach_products 
from apple_sales
order by Number_Of_Reviews desc) 
SELECT* FROM reached_products_by_custmer
WHERE top_reach_products<=2