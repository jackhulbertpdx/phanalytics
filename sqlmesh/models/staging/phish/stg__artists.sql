MODEL (
    name DEV_T1_STAGING.stg__artists,
    kind FULL,
    cron '@monthly',
    grain id
  );

with 

source as (

    select * from DEV_T0_RAW.PHISH_ARTISTS

),

renamed as (

    select
        _airbyte_raw_id,
        id,
        slug,
        artist,
        _airbyte_extracted_at

    from source

)

select * from renamed
