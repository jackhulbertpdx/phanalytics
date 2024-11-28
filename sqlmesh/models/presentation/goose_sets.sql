MODEL (
    name DEV_T3_PRESENTATION.GOOSE_SETS,
    kind FULL,
    cron '@daily',
    grain show_id
  );

with
    source as (select * from DEV_T2_EDW.FCT_GOOSE_SETS),
    shows as (select * from DEV_T2_EDW.FCT_GOOSE_SHOWS),
    spotify as (select * from DEV_T2_EDW.DIM_GOOSE_SPOTIFY_TRACKS),
        openers as (
        select show_id, is_original as opener_original, song_name as opener
        from source
        where sequence = 1
        group by 1, 2, 3
    ),
    a as (
        select
            show_id,
            song_name,
            is_original,
            sequence,
            max(sequence) over (partition by show_id order by sequence desc) m
        from source
    ),
    closers as (
        select show_id, is_original as closer_original, song_name as closer
        from a
        where m = sequence
        group by 1, 2, 3
    ),
    jam_score as (
        select
            rtrim(case
                when contains(song_name, '- Live')
                then left(song_name, position('- Live' in song_name) - 1)
                when contains(song_name, '-Live')
                then left(song_name, position(' -Live' in song_name) - 1)
                when contains(song_name, '(Live)')
                then left(song_name, position(' (Live)' in song_name) - 1)
                when contains(song_name, '(Live)')
                then left(song_name, position('(Live)' in song_name) - 1)
                else song_name
            end) song_name,
            avg(duration_seconds / 60 ) as length,
            avg(tempo) tempo,
            avg(energy) energy,
            avg(valence) valence,
            avg(liveness) liveness,
            avg(loudness) loudness,
            avg(acousticness) acousticness,
            avg(danceability) danceability,
            avg(time_signature) time_signature,
            avg(instrumentalness) instrumentalness,
            avg(
                tempo
                * energy
                * valence
                * danceability
                * (case when time_signature >= 4 then 1.2 else 1 end)
            ) as jam_score
        from spotify
        group by all
    ),

b as (
select 
a.show_id,
a.tour_name,
a.show_venue as venue,
a.show_date,
a.artist,
a.song_name as song,
a.sequence as song_order,
a.show_city as city,
a.show_state as state,
a.lat as latitude,
a.long as longitude,
a.country as country,
sh.artist as performing_artist,
case when a.is_original=false then 'Cover' else 'Original' end type,
b.opener_original,
b.opener,
c.closer_original,
c.closer,
a.state_name,
(ifnull(d.length,0) ) length,
ifnull(d.tempo,0) tempo,
ifnull(d.energy,0) energy,
ifnull(d.valence,0) valence,
ifnull(d.liveness,0) liveness,
ifnull(d.loudness,0) loudness,
ifnull(d.acousticness,0) acousticness,
ifnull(d.danceability,0) danceability,
ifnull(d.time_signature,0) time_signature,
ifnull(d.instrumentalness,0) instrumentalness,
ifnull(d.jam_score,0) jam_score
from
source a
left join shows sh on sh.show_id = a.show_id
left join openers b on a.show_id = b.show_id
left join closers c on a.show_id = c.show_id
left join jam_score d on a.song_name = d.song_name
)
select * from b group by all