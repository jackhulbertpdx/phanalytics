---
title: Jam Score
---

```sql date
select show_date
from sets
group by 1
```

```sql jams
select
show_date,
tour_name,
state,
venue,
CONCAT(left(show_date,11),' | ',venue, ' | ', city, ', ', state_name) as show,
country,type,
city,
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
from sets 
where show_date between '${inputs.date_range.start}' and '${inputs.date_range.end}'
group by all
order by show_date desc limit 5000

```


```sql jams_filtered
select
show_date,
tour_name,
venue,
'/shows/recent/' || show_id as link,
avg(jam_score) jam_score,
avg(acousticness) acousticness,
avg(instrumentalness) instrumentalness,
avg(danceability) danceabiliy,
avg(tempo) tempo,
avg(liveness) liveness,
avg(loudness) loudness,
avg(energy) energy,
avg(valence) valence, 
avg(length) length,
from sets 
where show_date between '${inputs.date_range.start}' and '${inputs.date_range.end}'
group by all
order by show_date desc limit 5000

```

<Modal title="Jam Score" buttonText='About the Jam Score 🎸'> 

The Jam Score is a composite metric that attempts to quantify the "jamminess" of a song using Spotify's audio features. It combines:

- Tempo - Speed of the song
- Energy - Intensity and activity
- Valence - Musical positiveness
- Danceability - How suitable for dancing
- Time Signature 

The score is calculated by multiplying these normalized values together, giving a relative measure of how likely a song is to feature extended improvisational sections. Higher scores generally indicate songs that are more conducive to jamming.

Note: This is an experimental metric and should be considered alongside other factors like actual jam history and show ratings.





</Modal>

<br/>
<DateRange
    name=date_range
    data={date}
    defaultValue={'Last 12 Months'}
    dates=show_date
/>

<Tabs color=#5A5A5A>
<Tab label="Show Analyis | Jam Score vs. Other Metrics">

<Grid cols=2>
    <ScatterPlot data={jams} x=instrumentalness y=jam_score fillColor=#2BB3DD outlineWidth=1 outlineColor=black tooltipTitle=show/>

    <ScatterPlot data={jams} x=acousticness y=jam_score fillColor=#FF6B24 outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=danceabiliy y=jam_score fillColor=#44FF44 lineColor=#44FF44 outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=danceabiliy y=jam_score fillColor=#9A2BDD lineColor=#9A2BDD outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=loudness y=jam_score fillColor=#FF2D95 lineColor=#FF2D95  outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=liveness y=jam_score fillColor=#FFE13C lineColor=#FFE13C outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=tempo y=jam_score fillColor=#2BB3DD lineColor=#2BB3DD outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=energy y=jam_score fillColor=#b8645e lineColor=#b8645e outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=valence y=jam_score fillColor=#015c08 lineColor=#015c08 outlineWidth=1 outlineColor=black tooltipTitle=show/>
    <ScatterPlot data={jams} x=length y=jam_score fillColor=#00FFA3 lineColor=#015c08 outlineWidth=1 outlineColor=black tooltipTitle=show/>
</Grid>
    </Tab>
    <Tab label="All Shows">



<DataTable data={jams_filtered}
link=link
/>
    </Tab>
</Tabs>