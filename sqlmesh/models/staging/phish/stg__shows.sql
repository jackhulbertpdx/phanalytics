MODEL (
    name DEV_T1_STAGING.stg__shows,
    kind FULL,
    cron '@daily',
    grain  _airbyte_raw_id
  );


with 

source as (

    select * from DEV_T0_RAW.PHISH_SHOWS
),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta,
        city,
        state as state_name,  -- renamed to avoid keyword
        venue,
        showid,
        tourid,
        country,
        showday,
        venueid,
        artistid,
        showdate,
        showyear,
        permalink,
        showmonth,
        tour_name,
        created_at,
        updated_at,
        artist_name,
        setlist_notes,
        exclude_from_stats

    from source

)

select * from renamed
