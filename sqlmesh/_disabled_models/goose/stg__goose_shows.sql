MODEL (
    name DEV_T1_STAGING.stg__goose_shows,
    kind FULL,
    cron '@monthly',
    grain  _airbyte_raw_id
  );


with 

source as (

    select * from DEV_T0_RAW.GOOSE_SHOWS
),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        city,
        state,
        venuename as venue,
        show_id as showid,
        tour_id as tourid,
        country,
        location,
        showorder,
        venue_id as venueid,
        artist_id as artistid,
        artist,
        showdate ,
        tourname as tour_name,
        created_at,
        updated_at
    from source

)

select * from renamed
