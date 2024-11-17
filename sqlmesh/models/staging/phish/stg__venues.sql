MODEL (
    name DEV_T1_STAGING.stg__venues,
    kind FULL,
    cron '@daily',
    grain  venueid
  );

with 

source as (

    select * from DEV_T0_RAW.PHISH_VENUES

),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta,
        city,
        alias,
        state,
        country,
        venueid,
        venuename,
        short_name,
        venuenotes

    from source

)

select * from renamed
