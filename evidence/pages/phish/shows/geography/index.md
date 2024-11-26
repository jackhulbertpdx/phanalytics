---
title: By Geography
---

```sql geo_link
SELECT 
 state,
 state_name,
 '/shows/geography/' || (state_name) as link,
count( distinct show_id) shows
FROM 
sets
where latitude!=0 and longitude !=0
GROUP BY 
    1,2,3
```


```sql states
select
count( distinct state) states
from sets
```


```sql countries
 select
 country,
 min(show_date) as first_show,
 max(show_date) as latest_show,
  '/shows/countries/' || (country) as link,
 '/'||country ||'.png' as flag,
count( distinct show_id) shows
FROM 
sets

GROUP BY 
    1
    order by shows desc
```



<Tabs color=#800080>


    
    <Tab label="USA">
Phish has played shows in <b><Value data={states} column=states/></b>  out of 50 US states.
<br>
<br>

<USMap
	data={geo_link}
	state=state
	value=shows
    link=link
	title="# of shows by State"
    subtitle="Click to view the show history for each state"
    colorPalette={['#CBC3E3','#800080','#800080']}
    legend=true
/>         </Tab>
    <Tab label="Global">

<DataTable data={countries}>
	<Column id=flag contentType=image height=30px align=center />
	<Column id=country />
	<Column id=first_show />
	<Column id=latest_show />
	<Column id=shows />
</DataTable>
   </Tab>
</Tabs>



Source: [phish.net](https://phish.net)