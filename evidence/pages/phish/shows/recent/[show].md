# <b><Value data={shows} column=artist_name /> at <Value data={shows} column=venue /></b> / <b><Value data={shows} column=show_date /></b>
📍<Value data={shows} column=city />, <Value data={shows} column=state />
```sql shows
select
city,
show_id,
venue,
artist_name,
STATE,
show_date,
count( show_id) as shows
from sets
where show_id = lower('${params.show}')
group by 1,2,3,4,5,6
```
```sql set_list
select
a.song as song,
'/phish/songs/popular/'|| b.spotify_song_id as link
from sets a
left join songs b on a.song = b.song 
where a.show_id = lower('${params.show}')
```
Historically, there have been <b><Value data={shows} column=shows /></b> shows played at <Value data={shows} column=venue />. 



<Tabs color=#5A5A5A>


    
<Tab label="Setlist">

<DataTable data={set_list} link=link />


</Tab>
    <Tab label="Similar shows">


```sql similar_shows
select
show_date,
venue,
city,
STATE,
tour_name,    
shared_songs_list,
'/phish/shows/recent/' || similar_show_id as link
from similar_shows
where base_show_id = lower('${params.show}')
group by all
```
<DataTable
    data={similar_shows}
    rowShading=true
    rowLines=true
    link=link
/>






   </Tab>
    <Tab label="Jam Analysis">

```sql jams_relative
select
show_date,
tour_name,
state,
venue,
CONCAT(left(show_date,11),' | ',venue, ' | ', city, ', ', state_name) as show,
country,
city,
case when show_id = lower('${params.show}') then TRUE ELSE FALSE END is_selected,
case when show_id = lower('${params.show}') then 10 ELSE 1 END size,
avg(jam_score) jam_score,
avg(acousticness) acousticness,
avg(instrumentalness) instrumentalness,
avg(danceability) danceabiliy,
avg(tempo) tempo,
avg(liveness) liveness,
avg(loudness) loudness,
avg(MEDIAN_RATING) plays,
avg(energy) energy,
avg(valence) valence, 
avg(length) length,
from sets where jam_score>0
group by all
order by show_date desc limit 500

```


## This show's jam metrics vs. other shows


<Grid cols=2>
    <BubbleChart data={jams_relative} x=instrumentalness y=jam_score series=is_selected size=size colorPalette={['#2BB3DD','#FFFFFF']} outlineWidth=1 outlineColor=black tooltipTitle=show />
    <BubbleChart data={jams_relative} x=acousticness y=jam_score series=is_selected size=size colorPalette={['#FF6B24','#FFFFFF']} outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <BubbleChart data={jams_relative} x=danceabiliy y=jam_score  series=is_selected size=size colorPalette={['#44FF44','#FFFFFF']} lineColor=#44FF44 outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <BubbleChart data={jams_relative} x=tempo y=jam_score  series=is_selected size=size colorPalette={['#9A2BDD','#FFFFFF']} lineColor=#9A2BDD outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <BubbleChart data={jams_relative} x=loudness y=jam_score  series=is_selected size=size colorPalette={['#FF2D95','#FFFFFF']}
     lineColor=#FF2D95  outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <BubbleChart data={jams_relative} x=liveness y=jam_score series=is_selected  size=size colorPalette={['#FFE13C','#FFFFFF']} lineColor=#FFE13C outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <BubbleChart data={jams_relative} x=tempo y=jam_score series=is_selected size=size colorPalette={['#2BB3DD','#FFFFFF']}
    lineColor=#2BB3DD outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <BubbleChart data={jams_relative} x=energy y=jam_score series=is_selected size=size  colorPalette={['#b8645e','#FFFFFF']} lineColor=#b8645e outlineWidth=1 outlineColor=black tooltipTitle=show/>

    
    <BubbleChart data={jams_relative} x=valence y=jam_score series=is_selected  size=size colorPalette={['#015c08','#FFFFFF']} 
   lineColor=#015c08 outlineWidth=1 outlineColor=black tooltipTitle=show/>

    <BubbleChart data={jams_relative} x=length y=jam_score     series=is_selected size=size
 colorPalette={['#00FFA3','#FFFFFF']} lineColor=#015c08 outlineWidth=1 outlineColor=black tooltipTitle=show/>
</Grid>





   </Tab>
</Tabs>

Source: [phish.net](https://phish.net)