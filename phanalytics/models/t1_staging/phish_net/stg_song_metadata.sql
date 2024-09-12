with 

source as (

    select * from DEV_T0_RAW.RAW_PHISH_SONG_METADATA

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
