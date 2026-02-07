MODEL (
    name DEV_T1_STAGING.stg__song_metadata,
    kind FULL,
    cron '@monthly',
    grain  songid
  );


with

source as (

    select * from DEV_T0_RAW.PHISH_SONG_METADATA

),

renamed as (

    select
        _extracted_at,
        slug,
        song,
        lyrics,
        songid,
        history,
        nickname,
        historian

    from source

)

select * from renamed
