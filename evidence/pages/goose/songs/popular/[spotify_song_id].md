# <Value data={songs_} column=song />

```sql songs_
select
song,
spotify_song_id,
sum(plays) lifetime_plays
from goose_songs
where spotify_song_id = ('${params.spotify_song_id}')
group by 1,2
order by lifetime_plays desc
```
<iframe style="border-radius:12px" src="https://open.spotify.com/embed/track/{params.spotify_song_id}?utm_source=generator" width="50%" height="142" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>
<BigValue 
data={songs_} 
value=lifetime_plays
/>


<BubbleChart 
    data={a_full} 
    x=plays 
    y=JAM_SCORE
    series=Active 
    size=JS
    legend=true
    chartAreaHeight=210
/>
<br>


```sql a
SELECT 
song,
    avg(TEMPO) tempo,
    avg(LENGTH) length,
    avg(ENERGY) energy,
    avg(VALENCE) valence,
    avg(LIVENESS) liveness,
    avg(LOUDNESS) loudness,
    avg(ACOUSTICNESS) acousticness,
    avg(DANCEABILITY) DANCEABILITY,
    avg(INSTRUMENTALNESS) INSTRUMENTALNESS,
    avg(JAM_SCORE) JAM_SCORE,
    MAX(avg(JAM_SCORE)) OVER () AS universal_max
from goose_sets
 where song = ('${params.song}')
group by 1
```
```sql a_full
SELECT 
s.song,
case when a.spotify_song_id = '${params.spotify_song_id}' then s.song else 'All other songs' end as Active,
    a.spotify_song_id,
    avg(s.TEMPO) tempo,
    count(distinct s.show_id) as plays,
    avg(s.LENGTH) length,
    avg(s.ENERGY) energy,
    avg(s.VALENCE) valence,
    avg(s.LIVENESS) liveness,
    avg(s.LOUDNESS) loudness,
    avg(s.ACOUSTICNESS) acousticness,
    avg(s.DANCEABILITY) DANCEABILITY,
    avg(s.INSTRUMENTALNESS) INSTRUMENTALNESS,
    avg(s.JAM_SCORE) JAM_SCORE,
    avg(case when a.spotify_song_id = '${params.spotify_song_id}' then s.JAM_SCORE*15 else 10 end ) as JS 
    from goose_sets s
left join (select song, min(spotify_song_id) spotify_song_id from songs group by 1) a on s.song = a.song 
group by 1,2,3
```

```sql recent
SELECT 
    CONCAT(s.opener, s.closer) AS opener_closer,
    s.opener,
    s.closer,
    a.spotify_song_id,
    avg(s.TEMPO) tempo,
    avg(s.LENGTH) length,
    avg(s.ENERGY) energy,
    avg(s.vALENCE) valence,
    avg(s.LIVENESS) liveness,
    avg(s.LOUDNESS) loudness,
    avg(s.ACOUSTICNESS) acousticness,
    avg(s.DANCEABILITY) DANCEABILITY,
    avg(s.INSTRUMENTALNESS) INSTRUMENTALNESS,
    avg(s.JAM_SCORE) JAM_SCORE,
    COUNT(  s.show_id) AS shows
FROM 
 goose_sets s
left join (select song, min(spotify_song_id) spotify_song_id from songs group by 1) a on s.opener = a.song or s.opener = a.song
 where a.spotify_song_id = '${params.spotify_song_id}'  
GROUP BY 
    s.opener, s.closer,a.spotify_song_id
ORDER BY 
    shows DESC
LIMIT 10
```

