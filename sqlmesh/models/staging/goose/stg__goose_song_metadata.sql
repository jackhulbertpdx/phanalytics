MODEL (
    name DEV_T1_STAGING.stg__goose_song_metadata,
    kind FULL,
    cron '@daily',
    grain  _airbyte_raw_id
  );


with 

source as (

    select * from DEV_T0_RAW.GOOSE_SONG_METADATA

),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        artist,
        artist_id as artistid,
        show_id as showid,
        showdate as show_date,
        songname as song,
        song_id as songid,
        value,
        city,
        state,
        country,
        venuename as venue
    from source

)

select * from renamed
