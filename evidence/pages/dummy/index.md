---
title: (Hidden) Partner Links
hide_title: true
sidebar_link: false
---

```sql dummy
SELECT 
 state,
 state_name,
 '/shows/geography/' || (state_name) as link,
count( distinct show_id) shows
FROM 
sets
GROUP BY 
    1,2,3
```
<DataTable data={dummy}
link=link
/>