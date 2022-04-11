{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  raw_staging: "raw_customer"
derived_columns:
  SOURCE: "!1"
  LOAD_DATETIME: "CRM_DATA_INGESTION_TIME"
  EFFECTIVE_FROM: "BOOKING_DATE"
  START_DATE: "BOOKING_DATE"
  END_DATE: "TO_DATE('9999-31-12')"
hashed_columns:
  CUSTOMER_HK: "CUSTOMER_ID"
  NATION_HK: "NATION_ID"
  CUSTOMER_NATION_HK:
    - "CUSTOMER_ID"
    - "NATION_ID"
  CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - "CUSTOMER_NAME"
      - "CUSTOMER_ID"
      - "CUSTOMER_PHONE"
      - "CUSTOMER_DOB"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}


{{ dbtvault.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=ranked_columns) }}