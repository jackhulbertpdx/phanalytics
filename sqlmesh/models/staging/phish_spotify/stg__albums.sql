MODEL (
    name DEV_T1_STAGING.stg__spotify_albums,
    kind FULL,
    cron '@monthly',
    grain id
  );

with 
source as (
    select * from DEV_T0_RAW.PHISH_ALBUMS
),
renamed as (
    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta,
        id,
        uri,
        href,
        name,
        type,
        images,
        artists,
        album_type,
        album_group,
        release_date,
        total_tracks,
        external_urls,
        available_markets,
        release_date_precision
    from source
)

select * from renamed