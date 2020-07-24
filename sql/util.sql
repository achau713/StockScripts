-- Count number of occurences of distinct values

SELECT colA, COUNT(colA) as count
FROM myTable 
GROUP BY colA

-- Count number of non null values in a column
SELECT 
    COUNT(*) - COUNT(colA) AS count_not_null_colA,
    COUNT(*) - COUNT(colB) AS count_not_null_colB
FROM myTable
    
-- Select items with the most recent date
-- Can extend this to group by multiple columns
SELECT 
    items, 
    MAX(datePurchased) AS 'Most recent purchase'
FROM itemTable
GROUP BY items

-- Assign row numbers to groups of a result set
SELECT 
    items,
    order_date,
    ROW_NUMBER() OVER(PARTITION BY(items) ORDER BY order_date)

-- Apply aggregate functions to groups of a result set
SELECT 
    items,
    price,
    MIN(price) OVER(PARTITION BY (items)),
    MAX(price) OVER(PARTITION BY (items)),
    AVG(price) OVER(PARTITION BY (items))


-- Pivot distinct values in a single column into new unique columns
-- Use CASE WHEN()


-- 