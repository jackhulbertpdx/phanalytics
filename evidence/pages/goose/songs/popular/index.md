
```sql songs
select
song,
avg(length) as duration
from goose_sets
where length >1
group by 1
limit 50
``` 

```sql songs_
select
song,
EARLIEST_SHOW_DATE,
LATEST_SHOW_DATE,
'/goose/songs/popular/'|| spotify_song_id as link,
sum(plays) plays
from goose_songs
where spotify_song_id is not null 
group by all
order by plays desc
limit 50
```


<DataTable
    data={songs_}
    link=link
/>