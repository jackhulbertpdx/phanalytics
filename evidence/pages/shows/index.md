

```sql sets_with_comp
select 
count( distinct case when YEAR(show_date) = YEAR(current_date()) then
show_id else null end)  cy_shows,
count( distinct case when YEAR(show_date) = YEAR(current_date())-1 and  month(show_date) < month(current_date()) then
show_id else null end)  py_shows,
(cy_shows - py_shows) as comp_shows,

count( distinct case when show_date BETWEEN current_date() - INTERVAL '365' DAY AND current_date() then
show_id else null end)  c365_shows,
count( distinct case when show_date BETWEEN current_date() - INTERVAL '730' DAY AND current_date() - INTERVAL '366' DAY
 then show_id else null end)  p365_shows,
(c365_shows - p365_shows) as comp365_shows,

count( distinct case when YEAR(show_date) <= YEAR(current_date())  AND YEAR(show_date) > YEAR(current_date())-5 then
show_id else null end)  c5y_shows,
count( distinct case when YEAR(show_date) <= YEAR(current_date())-5  AND YEAR(show_date) > YEAR(current_date())-10 then
show_id else null end)   p5y_shows,
(c5y_shows - p5y_shows) as comp_5y_shows,

count( distinct case when YEAR(show_date) <= YEAR(current_date())  AND YEAR(show_date) > YEAR(current_date())-10 then
show_id else null end)  c10y_shows,
count( distinct case when YEAR(show_date) <= YEAR(current_date())-10  AND YEAR(show_date) > YEAR(current_date())-20 then
show_id else null end)   p10y_shows,
(c10y_shows - p10y_shows) as comp_10y_shows,
count( distinct show_id) as lifetime
  from sets 
```
```sql time_series_year
select 
DATE_TRUNC('YEAR', show_date) as year, 
count(distinct show_id) as shows,
from sets
group by 1
```
```sql time_series_month
select 
month(show_date)  s, 
monthname(show_date)  m, 
count(distinct show_id) as shows,
from sets
group by 1,2
```
```sql recent_10
select 
venue,
concat(city,', ',state) City,
'/show/' || show_id as Details,
show_date
from sets
group by 1,2,3,4
order by show_date desc
limit 10
```

 <b><div style="text-align: left"> Show Stats </div> </b>
<BigValue 
title="This Year"
data={sets_with_comp} 
value=cy_shows
comparison=comp_shows
comparisonTitle="vs. LY"
/>

<BigValue 
title="Last 5 Years"
data={sets_with_comp} 
value=c5y_shows
comparison=comp_5y_shows
comparisonTitle="vs. L5Y"
/>
<BigValue 
title="Last 10 Years"
data={sets_with_comp} 
value=c10y_shows
comparison=comp_10y_shows
comparisonTitle="vs. L10Y"
/>
<BigValue 
title="Lifetime"
data={sets_with_comp} 
value=lifetime
/>
<br>
<br>
Explore Shows by:
<br>
<LinkButton url='/shows/recent/'>
Recent</LinkButton> 
<LinkButton url='/shows/geography/'>
Geo 🌎</LinkButton> 
<LinkButton url='/shows/jams/'>
Jams 🎸</LinkButton> 



<br>
<br>
 <b><div style="text-align: left"> Trend of Shows Played </div> </b>

<AreaChart 
    data={time_series_year} 
    x=year 
    y=shows
    colorPalette={['#800080']}
    yGridlines=true
echartsOptions={{
    dataZoom: [
        {
            start: 0,
            end: 100,
        },
    ],
    grid: {
        bottom: '50px',
    },
}}
/>



Source: [phish.net](https://phish.net)