

```sql geo
select
count(distinct show_id) as shows,
concat(MIN(MONTHNAME(SHOW_DATE)),' ',MIN(YEAR(SHOW_DATE)))  as first_show,
concat(MAX(MONTHNAME(SHOW_DATE)),' ',MAX(YEAR(SHOW_DATE))) as last_show,
from sets
where state_name = ('${params.state}') and latitude!=0 and longitude !=0

```
```sql cities
select
city,
state,
latitude,
longitude,
count(distinct show_id) as shows,
concat(MIN(MONTHNAME(SHOW_DATE)),' ',MIN(YEAR(SHOW_DATE)))  as first_show,
concat(MAX(MONTHNAME(SHOW_DATE)),' ',MAX(YEAR(SHOW_DATE))) as last_show,
from sets
where state_name = ('${params.state}') and latitude != 0 and latitude !=0
group by all
```
```sql cities_15
select
city,
state,
latitude,
longitude,
count(distinct show_id) as shows,
concat(MIN(MONTHNAME(SHOW_DATE)),' ',MIN(YEAR(SHOW_DATE)))  as first_show,
concat(MAX(MONTHNAME(SHOW_DATE)),' ',MAX(YEAR(SHOW_DATE))) as last_show,
from sets
where state_name = ('${params.state}') and latitude != 0 and latitude !=0
group by all
order by shows desc
limit 15
```
```sql shows
select
city,
state,
venue,
opener,
closer,
ARTIST_NAME,
latitude,
longitude,
show_date,
concat(MIN(YEAR(SHOW_DATE)),'-',MIN(MONTH(SHOW_DATE)))  as first_show,
concat(MAX(YEAR(SHOW_DATE)),'-',MAX(MONTH(SHOW_DATE))) as last_show
from sets
where state_name = ('${params.state}') and latitude != 0 and latitude !=0
group by all
order by show_date desc
```
# <Value data={cities} column=state/> 

<BigValue 
data={geo} 
value=shows
title="Total Shows"
/>
<BigValue 
data={geo} 
value=first_show
title="First Show"
/>
<BigValue 
data={geo} 
value=last_show
title="Latest Show"
/>
<Grid cols=2>
<BubbleMap 
    data={cities} 
    lat=latitude
    long=longitude
    value=shows 
    size=shows 
    pointName=city 
    tooltipType=hover
    colorPalette={['#CBC3E3','#800080','#800080']}
    tooltip={[
        {id: 'city', showColumnName: false, valueClass: 'text-xl font-semibold'},
        {id: 'shows',fieldClass: 'text-[grey]', valueClass: 'text-[green]'}
    ]}
/>
<BarChart 
    data={cities_15}
    x=city
    y=shows 
    swapXY=true
    colorPalette={['#800080','#800080','#800080']}
/>
</Grid>

# Full Show History
<DataTable data={shows} rowLines=true>
	<Column id=venue />
	<Column id=city />
	<Column id=artist_name />
	<Column id=show_date />
	<Column id=opener />
	<Column id=closer />
</DataTable>