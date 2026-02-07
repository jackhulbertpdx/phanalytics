MODEL (
    name DEV_T1_STAGING.stg__goose_songs,
    kind FULL,
    cron '@monthly',
    grain  songid
  );

with

    source as (select * from DEV_T0_RAW.GOOSE_SONGS),
    renamed as (

        select
            id as songid,
            isoriginal as is_original,
            name as song,
            ORIGINAL_ARTIST as artist,
            _airbyte_extracted_at

        from source

    )

select *
from renamed