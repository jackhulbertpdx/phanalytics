MODEL (
    name DEV_T1_STAGING.stg__goose_venues,
    kind FULL,
    cron '@daily',
    grain  venueid
  );

with 

source as (

    select * from DEV_T0_RAW.GOOSE_VENUES

),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta,
        city,
        state,
        country,
        venue_id as venueid,
        venuename,
        venuename as short_name
    from source

)

select * from renamed
