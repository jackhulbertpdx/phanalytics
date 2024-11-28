MODEL (
    name DEV_T1_STAGING.stg__goose_jamcharts,
    kind FULL,
    cron '@daily',
    grain  _airbyte_raw_id,

  );

with 

source as (

    select * from DEV_T0_RAW.GOOSE_JAMCHARTS

),

renamed as (

    select
        _airbyte_raw_id,
        setnumber as "set", 
        city,
        state,
        venuename,
        showid,
        song_id as songid,
        songname as song,
        country,
        artist_id,
        footnote,
        position,
        showdate,
        uniqueid,
        tracktime,
        artist,
        FOOTNOTE as setlistnotes,
        _airbyte_extracted_at
    from source

)

select * from renamed
