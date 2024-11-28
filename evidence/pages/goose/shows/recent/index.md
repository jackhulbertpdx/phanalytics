---
title: Recent Shows
---

```sql recent_50
select 
venue,
concat(city,', ',state) City,
'/goose/shows/recent/' || show_id as link,
show_date
from goose_sets
group by 1,2,3,4
order by show_date desc
limit 50
```
```sql recent_50_s
select 
venue,
state,
concat(city,', ',state) as Location,
show_date,
min(1) shows
from goose_sets
group by 1,2,3,4
order by show_date desc
limit 50
```
<USMap
    data={recent_50_s}
    state=state
    value=shows
    colorScale=blue
    min=-1
    max=5
    colorPalette={['#CBC3E3','#800080','#800080']}
/>
Click to View Show Details.
<DataTable data={recent_50}
link=link
/>

Sources: [phish.net](https://phish.net)