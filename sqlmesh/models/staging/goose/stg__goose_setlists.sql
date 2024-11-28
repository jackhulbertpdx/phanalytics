MODEL (
    name DEV_T1_STAGING.stg__goose_setlists,
    kind FULL,
    cron '@daily',
    grain  _airbyte_raw_id
);
with 
source as (
    select * from DEV_T0_RAW.goose_SETLISTS
),

renamed as (
    select
        _airbyte_raw_id,
        setnumber,  
        settype,
        shownotes,
        showtitle,
        city,
        slug,
        songname as song,
        state,  
        venuename,
        venue_id,
        show_id as show_id,
        song_id,
        tour_id,
        country,
        artist_id artistid,
        footnote,
        position,
        showdate,
        tourname, 
        uniqueid,
        tracktime,
        transition
        isjamchart,
        soundcheck
        isjam,
        artist as artist_name,
        isoriginal as is_original,
        _airbyte_extracted_at
    from source
)
select * from renamed
