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
song from sets

where show_id = lower('${params.show}')
```
Historically, there have been <b><Value data={shows} column=shows /></b> shows played at <Value data={shows} column=venue />. 



<Tabs color=#800080>


    
<Tab label="Setlist">
<DataTable
    data={set_list}
rowShading=true
rowNumbers=true
rowLines=true
/>
</Tab>
    <Tab label="Similar shows">
    Coming soon.
   </Tab>
    <Tab label="Jam Analysis">
    Coming soon.
   </Tab>
</Tabs>

Source: [phish.net](https://phish.net)