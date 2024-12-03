MODEL (
    name DEV_T1_STAGING.stg__songs,
    kind FULL,
    cron '@monthly',
    grain  songid
  );

with

    source as (select * from DEV_T0_RAW.PHISH_SONGS),
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