with

    source as (select * from DEV_T0_RAW.RAW_PHISH_SONGS),

    renamed as (

        select
            songid,
            gap,
            abbr,
            slug,
            song,
            debut,
            artist,
            last_played,
            times_played,
            last_permalink,
            debut_permalink,
            _airbyte_extracted_at

        from source

    )

select *
from renamed
