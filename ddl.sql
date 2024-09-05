CREATE TABLE `dk4learning-433311.ds_gads.w_company_score`
(
  company_name STRING,
  timely_response_count INT64,
  total_complaints INT64
);

CREATE TABLE `dk4learning-433311.ds_gads.complaints_tracking`
(
  company_name STRING,
  complaints_30_days INT64,
  complaints_90_days INT64,
  complaints_180_days INT64,
  complaints_365_days INT64,
  complaints_timestamp DATETIME
);

CREATE TABLE `dk4learning-433311.ds_gads.company_category`
(
  company_name STRING,
  category STRING,
  created_ts TIMESTAMP
);

CREATE TABLE `dk4learning-433311.ds_gads.company_360`
(
  company_name STRING,
  category STRING,
  complaints_30_days INT64,
  complaints_90_days INT64,
  complaints_180_days INT64,
  complaints_365_days INT64,
  complaints_timestamp DATETIME
);
