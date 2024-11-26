---
title: Openers and Closers
---


```sql recent
SELECT 
    CONCAT(opener, closer) AS opener_closer,
    opener,
    closer,
    artist_name,
    COUNT(show_id) AS shows
FROM 
 sets
GROUP BY 
    opener, closer,artist_name
ORDER BY 
    shows DESC
LIMIT 25
```

```sql openers
SELECT 
    opener,
    artist_name,
min(SHOW_DATE) first_play,
max(SHOW_DATE) last_play,
    COUNT( distinct show_id) AS shows
FROM 
 sets
GROUP BY all
ORDER BY 
    shows DESC
```

```sql closers
SELECT 
    closer,
    artist_name,
min(SHOW_DATE) first_play ,
max(SHOW_DATE) last_play,
    COUNT( distinct show_id) AS shows
FROM 
 sets
GROUP BY all
ORDER BY 
    shows DESC
```
```sql date
SELECT 
show_date from sets
```


<Tabs color=#800080>
    <Tab label="Top Openers">

<DataTable data={openers}> 
	<Column id=opener/> 
	<Column id=first_play/> 
	<Column id=last_play/> 
	<Column id=shows/> 
</DataTable>
/>
    </Tab>
    <Tab label="Top Closers">
<DataTable data={closers}> 
	<Column id=closer/> 
	<Column id=first_play/> 
	<Column id=last_play/> 
	<Column id=shows/> 
</DataTable>
    </Tab>
    <Tab label="Combos">
<b>Top 15 Opener and Closer Combos</b>
<SankeyDiagram 
    data={recent} 
    sourceCol= opener
    targetCol = closer
    valueCol= shows
    chartAreaHeight=500
/>

    </Tab>
</Tabs>


Source: [phish.net](https://phish.net)