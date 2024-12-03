MODEL (
    name DEV_T2_EDW.fct_songs,
    kind FULL,
    cron '@monthly',
    grain  songid
  );
with
    songs as (select * from DEV_T1_STAGING.stg__songs),
    lyrics as (select * from DEV_T1_STAGING.stg__song_metadata),

    joined as (
        select
            s.songid song_id,
            s.gap,
            s.song song_name,
            cast(s.debut as date) song_debut,
            s.artist original_artist,
            s.last_played last_played_date,
            s.times_played play_count,
 REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(l.lyrics, '<p>', ''), '</p>', ''), '<main>', ''), '</main>', ''),'</a>',''),'<a>','') song_lyrics,
 REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(l.history, '<p>', ''), '</p>', ''), '<main>', ''), '</main>', ''),'</a>',''),'<a>','') song_history
        from songs s 
        join lyrics l on s.songid = l.songid

    )
    select * from joined
