MODEL (
    name DEV_T3_PRESENTATION.GOOSE_SETS,
    kind FULL,
    cron '@monthly',
    grain show_id
);

with 
    shows as (select * from DEV_T2_EDW.FCT_GOOSE_SHOWS),
    source as (select * from DEV_T2_EDW.FCT_GOOSE_SETS),
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
            avg(duration_seconds / 60) as length,
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
    )

select 
    sh.show_id,
    sh.tour_name,
    sh.show_venue as venue,
    sh.show_date,
    sh.artist,
    s.song_name as song,
    s.sequence as song_order,
    sh.show_city as city,
    sh.show_state_us as state,
    sh.lat as latitude,
    sh.long as longitude,
    sh.show_country as country,
    sh.artist as performing_artist,
    case when s.is_original=false then 'Cover' else 'Original' end type,
    o.opener_original,
    o.opener,
    c.closer_original,
    c.closer,
    s.state_name,
    coalesce(j.length, 0) length,
    coalesce(j.tempo, 0) tempo,
    coalesce(j.energy, 0) energy,
    coalesce(j.valence, 0) valence,
    coalesce(j.liveness, 0) liveness,
    coalesce(j.loudness, 0) loudness,
    coalesce(j.acousticness, 0) acousticness,
    coalesce(j.danceability, 0) danceability,
    coalesce(j.time_signature, 0) time_signature,
    coalesce(j.instrumentalness, 0) instrumentalness,
    coalesce(j.jam_score, 0) jam_score,
    source
from shows sh
left join source s on s.show_id = sh.show_id
left join openers o on sh.show_id = o.show_id
left join closers c on sh.show_id = c.show_id
left join jam_score j on s.song_name = j.song_name
group by all