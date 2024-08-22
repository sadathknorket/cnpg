-- Drop existing tables if they exist
DROP MATERIALIZED VIEW IF EXISTS mv_normal;
DROP TABLE IF EXISTS pgbench_accounts;
DROP TABLE IF EXISTS pgbench_branches;

-- Create sample tables
CREATE TABLE pgbench_accounts (
    aid INT PRIMARY KEY,
    abalance INT,
    bid INT -- Ensure this column exists for the join
);

CREATE TABLE pgbench_branches (
    bid INT PRIMARY KEY,
    bbalance INT
);

-- Insert some sample data
INSERT INTO pgbench_accounts (aid, abalance, bid) VALUES (1, 1000, 1), (2, 2000, 2);
INSERT INTO pgbench_branches (bid, bbalance) VALUES (1, 500), (2, 600);


-- Create a normal materialized view
CREATE MATERIALIZED VIEW mv_normal AS
SELECT a.aid, b.bid, a.abalance, b.bbalance
FROM pgbench_accounts a
JOIN pgbench_branches b ON a.bid = b.bid; -- Use explicit join condition

-- Test REFRESH MATERIALIZED VIEW
REFRESH MATERIALIZED VIEW mv_normal;


-- Create the pg_ivm extension
CREATE EXTENSION pg_ivm;

-- Create an IMMV
SELECT create_immv('immv', 'SELECT a.aid, b.bid, a.abalance, b.bbalance FROM pgbench_accounts a JOIN pgbench_branches b ON a.bid = b.bid');

-- Test updating base tables and IMMV
UPDATE pgbench_accounts SET abalance = 1234 WHERE aid = 1;
SELECT * FROM immv WHERE aid = 1;

-- Drop index for further testing
DROP INDEX IF EXISTS immv_index;

-- Update base tables and test performance without index
UPDATE pgbench_accounts SET abalance = 9876 WHERE aid = 1;
SELECT * FROM immv WHERE aid = 1;
