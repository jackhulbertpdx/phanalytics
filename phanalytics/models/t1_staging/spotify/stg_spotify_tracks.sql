with

    source as (select * from DEV_T0_RAW.RAW_SPOTIFY_TRACKS),

    renamed as (

        select
            id,
            uri,
            href,
            name,
            type,
            artists,
            explicit,
            is_local,
            disc_number,
            duration_ms,
            preview_url,
            track_number,
            external_urls,
            available_markets,
            _airbyte_extracted_at
        from source

    )

select *
from renamed
