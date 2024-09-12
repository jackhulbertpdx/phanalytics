with 

source as (

    select * from DEV_T0_RAWRAW_SPOTIFY_AUDIO_ANALYSIS

),

renamed as (

    select

        bars,
        meta,
        beats,
        track,
        tatums,
        sections,
        segments
        _airbyte_extracted_at,

    from source

)

select * from renamed
