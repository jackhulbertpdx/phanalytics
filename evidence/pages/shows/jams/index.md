---
title: By Jam Score
---
```sql jams
select
show_id,
show_date,
year(show_date) as year,
tour_name,
state,
country,type,
city,
sum(jam_score) jam_score,
median(jam_score) jam_score_med,
round(sum(case when type='Cover' then jam_score else 0 end)/ sum(jam_score),2)*100 pct_covers
from sets 
group by all
order by median(jam_score) desc

```
```sql original_jam
select
year(show_date) as year,
type,
sum(jam_score) jam_score
from sets 
group by all
```

<Modal title="Jam Score" buttonText='About the Jam Score 🎸'> 

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 

</Modal>


### Jam score over time
<BarChart 
    data={jams}
    x=year
    y=jam_score 
    yAxisTitle="Jam Score over Time"
/>
Breakdown by Covers / Originals
<BarChart 
    data={original_jam}
    x=year
    y=jam_score
    yFmt=pct0
    series=type
    type=stacked100
/>

