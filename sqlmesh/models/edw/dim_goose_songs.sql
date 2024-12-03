MODEL (
    name DEV_T2_EDW.fct_goose_songs,
    kind FULL,
    cron '@monthly',
    grain  songid
  );
with
    songs as (select * from DEV_T1_STAGING.stg__goose_songs),

    joined as (
        select
            s.songid song_id,
            s.song song_name,
            s.artist original_artist
        from songs s 

    )
    select * from joined
