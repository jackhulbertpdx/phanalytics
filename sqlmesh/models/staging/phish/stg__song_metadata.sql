MODEL (
    name DEV_T1_STAGING.stg__song_metadata,
    kind FULL,
    cron '@daily',
    grain  _airbyte_raw_id
  );


with 

source as (

    select * from DEV_T0_RAW.PHISH_SONG_METADATA

),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta,
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
