MODEL (
    name DEV_T3_PRESENTATION.PHISH_SONGS,
    kind FULL,
    cron '@monthly',
    grain song_id
  );

with
    source as (select * from DEV_T2_EDW.FCT_SETS),
    shows as (select * from DEV_T2_EDW.FCT_SHOWS),
    spotify as (select * from DEV_T2_EDW.DIM_SPOTIFY_TRACKS),
    earliest_latest_shows as (
        select
            song_id,
            song_name,
            case when is_original = true then 'Original' else 'Cover' end as cover,
            min(show_date) as earliest_show_date,
            max(show_date) as latest_show_date,
            count(distinct set_id) as plays
        from source
        group by song_id, song_name, cover
    ),
    last_30 as (
        select song_name, count(distinct set_id) as last_30_plays
        from source
        where show_date >= dateadd(year, -1, current_date())
        group by song_name
    ),
    last_15 as (
        select song_name, count(distinct set_id) as last_15_plays
        from source
        where show_date >= dateadd(year, -15, current_date())
        group by song_name
    ),
    yoy as (
        select song_id, 
               count(distinct case when show_date >= dateadd(year, -1, current_date()) then set_id end) /
               nullif(count(distinct case when show_date between dateadd(year, -2, current_date()) and dateadd(year, -1, current_date()) then set_id end), 0) as yoy
        from source
        group by song_id
    ),
    spotify_id as (
        select song_name, min(spotify_song_id) as id
        from spotify
        group by song_name
    )
select
    els.song_id,
    els.song_name,
    els.cover,
    spotify_id.id as spotify_song_id,
    els.earliest_show_date as earliest_show_date,
    els.latest_show_date as latest_show_date,
    st_earliest.show_city as earliest_show_city,
    coalesce(st_earliest.show_state, st_earliest.show_country) as earliest_show_state,
    st_earliest.show_venue as earliest_venue,
    st_latest.show_venue as latest_venue,
    st_latest.show_city as latest_show_city,
    coalesce(st_latest.show_state, st_latest.show_country) as latest_show_state,
    els.plays as plays,
    coalesce(last_30.last_30_plays, 0) as last_30_plays,
    coalesce(last_15.last_15_plays, 0) as last_15_plays,
    coalesce(yoy.yoy, 0) as year_over_year
from earliest_latest_shows els
left join source as st_earliest
    on els.song_name = st_earliest.song_name
    and els.earliest_show_date = st_earliest.show_date
left join source as st_latest
    on els.song_name = st_latest.song_name
    and els.latest_show_date = st_latest.show_date
left join last_30 on els.song_name = last_30.song_name
left join last_15 on els.song_name = last_15.song_name
left join spotify_id on els.song_name = spotify_id.song_name
left join yoy on els.song_id = yoy.song_id 
group by all
