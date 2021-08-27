USE customer_analysis;

-- Copy the table into a table that we will use for cleaning
CREATE TABLE customer AS SELECT * FROM raw_data;

/* Cleaning steps: standardizing column names, dropping customer column, Drop duplicates and reset index
replacing null values ("number_of_open_complaints", "months_since_last_claim", "income") */

-- Drop "customer" columns
ALTER TABLE customer_analysis.customer
DROP COLUMN Customer;

-- Rename the column that will be the primary key, and renaming it
ALTER TABLE customer RENAME COLUMN MyUnknownColumn TO customer_index;

ALTER TABLE customer
ADD PRIMARY KEY (customer_index);

-- Rename columns
ALTER TABLE customer 
CHANGE State state VARCHAR(30),
CHANGE `Customer Lifetime Value` customer_lifetime_value DOUBLE,
CHANGE `Effective To Date` effective_to_date TEXT,
CHANGE `Marital Status` marital_status TEXT,
CHANGE `Monthly Premium Auto` monthly_premium_auto INT,
CHANGE `Months Since Last Claim` months_since_last_claim TEXT,
CHANGE `Months Since Policy Inception` months_since_policy_inception INT,
CHANGE `Number Of Open Complaints` number_of_open_complaints TEXT,
CHANGE `Number of Policies` number_of_policies INT,
CHANGE `Policy Type` policy_type TEXT,
CHANGE `Renew Offer Type` renew_offer_type TEXT,
CHANGE `Sales Channel` sales_channel TEXT,
CHANGE `Total Claim Amount` total_claim_amount DOUBLE,
CHANGE `Vehicle Class` vehicle_class TEXT,
CHANGE `Vehicle Size` vehicle_size TEXT,
CHANGE `Vehicle Type` vehicle_type TEXT;

ALTER TABLE customer CHANGE `Location Code` location_code TEXT; -- I forgot this one

-- Replacing null values in number of open complaints
UPDATE customer
SET number_of_open_complaints = 0
WHERE number_of_open_complaints NOT IN (1,2,3,4,5); 

-- Cast the column to INT
ALTER TABLE customer
MODIFY COLUMN number_of_open_complaints INT;

-- Now the column months_since_last_claim

SELECT ROUND(AVG(months_since_last_claim)) FROM customer; -- This result is 14

UPDATE customer
SET months_since_last_claim = 14
WHERE months_since_last_claim="";

ALTER TABLE customer
MODIFY COLUMN months_since_last_claim INT;

-- Drop duplicates. First we create an empty table with the same structure, then we fill it with the distinct values from the original one

SELECT customer_index FROM (SELECT customer_index 
FROM customer 
GROUP BY 
`state` ,
`customer_lifetime_value`,
`Response` ,
`Coverage`,
`Education`,
`effective_to_date`,
`EmploymentStatus` ,
`Gender`,
`Income`,
`location_code` ,
`marital_status`,
`monthly_premium_auto`,
`months_since_last_claim`,
`months_since_policy_inception` ,
`number_of_open_complaints`,
`number_of_policies` ,
`policy_type` ,
`Policy` ,
`renew_offer_type` ,
`sales_channel` ,
`total_claim_amount` ,
`vehicle_class` ,
`vehicle_size` ,
`vehicle_type` 
HAVING COUNT(*) > 1) as duplicates;


SELECT * FROM customer WHERE customer_index IN 
(SELECT customer_index FROM (SELECT customer_index 
FROM customer 
GROUP BY 
`state` ,
`customer_lifetime_value`,
`Response` ,
`Coverage`,
`Education`,
`effective_to_date`,
`EmploymentStatus` ,
`Gender`,
`Income`,
`location_code` ,
`marital_status`,
`monthly_premium_auto`,
`months_since_last_claim`,
`months_since_policy_inception` ,
`number_of_open_complaints`,
`number_of_policies` ,
`policy_type` ,
`Policy` ,
`renew_offer_type` ,
`sales_channel` ,
`total_claim_amount` ,
`vehicle_class` ,
`vehicle_size` ,
`vehicle_type` 
HAVING COUNT(*) > 1) as duplicates);





