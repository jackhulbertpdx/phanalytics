---
title: Artists
---


```sql artists
SELECT 
 performing_artist,
count( distinct show_id) shows
FROM 
goose_sets
GROUP BY 1
```

<DataTable data={artists}>
	<Column id=performing_artist />
	<Column id=shows />
</DataTable>