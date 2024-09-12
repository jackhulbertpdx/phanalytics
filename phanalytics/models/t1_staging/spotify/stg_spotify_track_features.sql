with 

source as (

    select * from DEV_T0_RAW.RAW_SPOTIFY_TRACK_FEATURES

),

renamed as (

    select

        id,
        key,
        uri,
        mode,
        type,
        tempo,
        energy,
        valence,
        liveness,
        loudness,
        track_href,
        duration_ms,
        speechiness,
        acousticness,
        analysis_url,
        danceability,
        time_signature,
        instrumentalness,
        _airbyte_extracted_at

    from source)
select * from renamed