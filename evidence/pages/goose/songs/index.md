
```sql songs
select
song,
min(show_date) as debuted,
max(show_date) as last_played,
round(avg(length)) as duration,
count(distinct show_id) as lifetime_plays
from goose_sets
where length >1
group by 1
order by lifetime_plays desc
```
```sql song_count
select
count(distinct song) as songs,
round(avg(length),1) duration
from goose_sets
```

<BigValue 
data={song_count} 
value=songs
title="All Songs in Catalog"
/>
<BigValue 
data={song_count} 
value=duration
title="Average Length (Min)"
/>
<br>
Explore Songs by:
<br>
<LinkButton url='/goose/songs/popular/'>
Popularity 📈</LinkButton> 
<LinkButton url='/goose/songs/sequence/'>
Openers and Closers 🚪</LinkButton> 


<Histogram
    data={songs} 
    x=duration 
    xAxisTitle="Duration in Minutes"
    title="Distribution of Songs by Duration (minutes)"
    colorPalette={['#800080']}
/>