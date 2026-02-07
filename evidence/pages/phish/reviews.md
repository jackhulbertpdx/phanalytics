# Phish Show Reviews

```sql recent_reviews
SELECT
    show_date,
    show_venue as venue,
    show_city as city,
    show_state as state,
    rating_score,
    review_text,
    posted_at
FROM reviews
ORDER BY posted_at DESC
LIMIT 100
```

```sql avg_rating_by_year
SELECT
    YEAR(show_date) as year,
    COUNT(*) as review_count,
    AVG(rating_score) as avg_rating
FROM reviews
GROUP BY 1
ORDER BY 1 DESC
```

## Recent Reviews

<DataTable data={recent_reviews} rows=20/>

## Average Ratings by Year

<BarChart
    data={avg_rating_by_year}
    x=year
    y=avg_rating
    colorPalette={['#800080']}
/>

<DataTable data={avg_rating_by_year}/>

---
Source: [phish.net](https://phish.net)
