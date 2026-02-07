MODEL (
    name DEV_T1_STAGING.stg__shows,
    kind FULL,
    cron '@monthly',
    grain  showid
  );


with

source as (

    select * from DEV_T0_RAW.PHISH_SHOWS
),

renamed as (

    select
        _extracted_at,
        city,
        state,
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
