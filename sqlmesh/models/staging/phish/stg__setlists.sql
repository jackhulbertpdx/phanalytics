MODEL (
    name DEV_T1_STAGING.stg__setlists,
    kind FULL,
    cron '@monthly',
    grain  _airbyte_raw_id
);
with 
source as (
    select * from DEV_T0_RAW.PHISH_SETLISTS
),

renamed as (
    select
        _airbyte_raw_id,
        gap,
        set,  
        city,
        meta,
        slug,
        song,
        isjam,
        state,  
        venue,
        showid,
        songid,
        tourid,
        country,
        reviews,
        venueid,
        artistid,
        footnote,
        nickname,
        position,
        showdate,
        showyear,
        tourname,
        tourwhen,
        uniqueid,
        isreprise,
        permalink,
        tracktime,
        isjamchart,
        soundcheck,
        trans_mark,
        transition,
        artist_name,
        artist_slug,
        is_original,
        setlistnotes,
        jamchart_description,
        _airbyte_extracted_at
    from source
)
select * from renamed