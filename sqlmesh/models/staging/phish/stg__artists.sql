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
        id,
        slug,
        artist,
        _extracted_at

    from source

)

select * from renamed
