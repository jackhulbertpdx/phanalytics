MODEL (
    name DEV_T2_EDW.DIM_SPOTIFY_TRACKS,
    kind FULL,
    cron '@daily',
    grain spotify_song_id
  );

with songs as (select * from DEV_T1_STAGING.stg__spotify_tracks),
track_features as (select * from DEV_T1_STAGING.stg__spotify_track_features),

joined as (
select 
        s.id spotify_song_id,
        name song_name,
        s.disc_number,
        s.duration_ms * .001 as duration_seconds,
        s.preview_url,
        s.track_number,
        t.mode,
        t.type,
        t.tempo,
        t.energy,
        t.valence,
        t.liveness,
        t.loudness,
        t.speechiness,
        t.acousticness,
        t.danceability,
        t.time_signature,
        t.instrumentalness
        
         from songs s
        left join track_features t on s.id = t.id
)
select * from joined j
group by all