insert ds_gads.w_company_score
SELECT
    complaints.company_name,
    count(CASE
      WHEN complaints.timely_response THEN 1
      ELSE CAST(NULL as INT64)
    END) AS timely_response_count,
    count(*) AS total_complaints
  FROM
    `dk4learning-433311.ds_ent.complaints` AS complaints
  GROUP BY 1;

insert into ds_gads.company_category
SELECT
    intermediate_table.company_name,
    CASE
      WHEN intermediate_table.timely_response_count / intermediate_table.total_complaints >= 0.8 THEN 'good'
      WHEN intermediate_table.timely_response_count / intermediate_table.total_complaints >= 0.5 THEN 'average'
      ELSE 'poor'
    END AS category,
    current_timestamp()
  FROM
    ds_gads.w_company_score as intermediate_table;

insert into ds_gads.complaints_tracking
SELECT
    company.company_name,
    count(CASE
      WHEN DATE_DIFF(CURRENT_DATE(), complaints.date_sent_to_company, DAY) <= 30 THEN 1
      ELSE CAST(NULL as INT64)
    END) AS complaints_30_days,
    count(CASE
      WHEN DATE_DIFF(CURRENT_DATE(), complaints.date_sent_to_company, DAY) <= 90 THEN 1
      ELSE CAST(NULL as INT64)
    END) AS complaints_90_days,
    count(CASE
      WHEN DATE_DIFF(CURRENT_DATE(), complaints.date_sent_to_company, DAY) <= 180 THEN 1
      ELSE CAST(NULL as INT64)
    END) AS complaints_180_days,
    count(CASE
      WHEN DATE_DIFF(CURRENT_DATE(), complaints.date_sent_to_company, DAY) <= 365 THEN 1
      ELSE CAST(NULL as INT64)
    END) AS complaints_365_days,
    CURRENT_DATETIME() as complaints_timestamp
  FROM
    `dk4learning-433311.ds_ent.company` AS company
    left JOIN `dk4learning-433311.ds_ent.complaints` AS complaints ON company.company_name = complaints.company_name
  GROUP BY 1;

insert into ds_gads.company_360
SELECT
    complaints_tracking.company_name,
    company_category.category,
    complaints_tracking.complaints_30_days,
    complaints_tracking.complaints_90_days,
    complaints_tracking.complaints_180_days,
    complaints_tracking.complaints_365_days,
    complaints_tracking.complaints_timestamp
    
  FROM
    `dk4learning-433311.ds_gads.complaints_tracking` AS complaints_tracking
    LEFT OUTER JOIN `dk4learning-433311.ds_gads.company_category` AS company_category ON complaints_tracking.company_name = company_category.company_name;
