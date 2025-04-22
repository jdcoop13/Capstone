----- Data Loading:

-- Create a schema named finance, set finance as the default schema, 
-- and create tables with cc_data.csv and location_data.csv 

CREATE TABLE IF NOT EXISTS cc_data (
	'index' NUMERIC PRIMARY KEY,
	trans_date_trans_time DATETIME,
	cc_num NUMERIC,
	merchant VARCHAR (255),
	category VARCHAR (255),
	amt NUMERIC,
	first VARCHAR (255),
	last VARCHAR (255),
	gender VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (255),
	zip NUMERIC,
	lat NUMERIC,
	long NUMERIC,
	city_pop NUMERIC,
	job VARCHAR (255),
	dob DATE,
	trans_num NUMERIC,
	unix_time NUMERIC,
	merch_lat NUMERIC,
	merch_long NUMERIC,
	is_fraud NUMERIC
)

SELECT *
FROM cc_data

-- Had to drop and remake this table because amt was a currency in excel and sql was reading as a text
DROP TABLE IF EXISTS cc_data

CREATE TABLE IF NOT EXISTS location_data (
	cc_num NUMERIC,
	lat NUMERIC,
	long NUMERIC,
	FOREIGN KEY (cc_num) REFERENCES cc_data(cc_num),
	FOREIGN KEY (lat) REFERENCES cc_data(lat),
	FOREIGN KEY (long) REFERENCES cc_data(long)
)

SELECT *
FROM location_data

-- Had to drop and remake to add a foreign key to join the tables
DROP TABLE IF EXISTS location_data

----- Data Exploration with SQL:

-- Calculate the total number of transactions in the cc_data table

SELECT *
FROM cc_data

SELECT COUNT(trans_num) as total_transactions
FROM cc_data

-- Identify the top 10 most frequent merchants in the cc_data table

SELECT merchant, COUNT(*) as frequency
FROM cc_data
GROUP BY merchant
ORDER BY frequency DESC LIMIT 10

-- Find the average transaction amount for each category of transactions in the cc_data table

SELECT *
FROM cc_data

SELECT category, ROUND(avg(amt),2) as avg_amt
FROM cc_data
GROUP BY category

-- Determine the number of fraudulent transactions and the percentage of total transactions that they represent

SELECT *
FROM cc_data

SELECT COUNT(*) as total_transactions
, SUM(CASE WHEN is_fraud = 1 
		THEN 1 
		ELSE 0 
		END) as fraud_trans
, ROUND( 100.0 * SUM(CASE WHEN is_fraud = 1 
		THEN 1 
		ELSE 0 
	END) / COUNT(*),2) || '%' as percent_of_fraud_trans
FROM cc_data


-- Join the cc_data and location_data tables to identify the latitude and longitude of each transaction

SELECT *
FROM cc_data c
LEFT JOIN location_data lc on c.cc_num = lc.cc_num

-- Identify the city with the highest population in the location_data table

SELECT city, state, city_pop
FROM cc_data c
LEFT JOIN location_data lc on c.cc_num = lc.cc_num
GROUP BY city, state, city_pop
ORDER BY city_pop DESC

-- Find the earliest and latest transaction dates in the cc_data table

SELECT MIN(trans_date_trans_time) as earliest_trans_date
, MAX(trans_date_trans_time) as latest_trans_date
FROM cc_data


----- Using Data Aggregation with SQL:

-- What is the total amount spent across all transactions in the cc_data table?

SELECT sum(amt) as all_trans_total
FROM cc_data

-- How many transactions occurred in each category in the cc_data table?

SELECT category, COUNT(trans_num) as transactions
FROM cc_data
GROUP BY category

-- What is the average transaction amount for each gender in the cc_data table?

SELECT gender, ROUND(avg(amt),2) as avg_transaction_amount
FROM cc_data
GROUP BY gender

-- Which day of the week has the highest average transaction amount in the cc_data table

SELECT 
	CASE strftime( '%w', trans_date_trans_time)
		WHEN '0' THEN 'Sunday'
		WHEN '1' THEN 'Monday'
		WHEN '2' THEN 'Tuesday'
		WHEN '3' THEN 'Wednesday'
		WHEN '4' THEN 'Thursday'
		WHEN '5' THEN 'Friday'
		WHEN '6' THEN 'Saturday'	
	END as weekday, avg(amt) as avg_trans_amt
FROM cc_data
GROUP BY weekday
ORDER BY avg_trans_amt 























