MODEL (
    name DEV_T3_PRESENTATION.GOOSE_SIMILAR_SHOWS,
    kind FULL,
    cron '@daily',
    grain base_show_id
);
WITH show_setlists AS (
    -- Materialize basic show info and songs once
    SELECT 
        show_id,
        show_date,
        tour_name,
        YEAR(show_date) as show_year,
        ARRAY_AGG(song) WITHIN GROUP (ORDER BY song_order) as songs,
        COUNT(*) as total_songs  -- Pre-calculate song count
    FROM DEV_T3_PRESENTATION.GOOSE_SETS
    GROUP BY show_id, show_date, tour_name, show_year 
),
show_pairs AS (
    -- First just get potential show pairs within time window
    SELECT 
        a.show_id as base_show_id,
        b.show_id as similar_show_id,
        a.show_date as base_date,
        b.show_date as similar_date,
        a.tour_name as base_tour,
        b.tour_name as similar_tour,
        a.songs as base_songs,
        b.songs as other_songs,
        a.total_songs as base_total,
        b.total_songs as other_total
    FROM show_setlists a
    INNER JOIN show_setlists b
    ON a.show_id < b.show_id  -- Keep this to control record count
    AND ABS(a.show_year - b.show_year) <= 25
),
similarity_calcs AS (
    -- Do array operations only on time-filtered pairs
    SELECT 
        sp.base_show_id,
        sp.similar_show_id,
        sp.base_date,
        sp.similar_date,
        sp.base_tour,
        sp.similar_tour,
        sp.base_total,
        sp.other_total,
        ARRAY_INTERSECTION(sp.base_songs, sp.other_songs) as shared_songs_list,
        ARRAY_SIZE(ARRAY_INTERSECTION(sp.base_songs, sp.other_songs)) as shared_count
    FROM show_pairs sp
),
final_filtered AS (
    -- Apply similarity filters with adjusted thresholds
    SELECT 
        sc.base_show_id,
        sc.similar_show_id,
        sc.base_date,
        sc.similar_date,
        sc.base_tour,
        sc.similar_tour,
        sc.shared_songs_list,
        sc.shared_count,
        sc.shared_count::FLOAT / (sc.base_total + sc.other_total - sc.shared_count)::FLOAT as similarity_score,
        sc.base_tour = sc.similar_tour as tour_similarity,
        ABS(YEAR(sc.base_date) - YEAR(sc.similar_date)) as year_difference
    FROM similarity_calcs sc
    WHERE sc.shared_count >= 4
    AND sc.shared_count::FLOAT / (sc.base_total + sc.other_total - sc.shared_count)::FLOAT >= 0.2
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY sc.base_show_id 
        ORDER BY 
            sc.shared_count::FLOAT / (sc.base_total + sc.other_total - sc.shared_count)::FLOAT DESC,
            sc.shared_count DESC,
            -ABS(YEAR(sc.base_date) - YEAR(sc.similar_date))  -- Prefer closer years
    ) <= 25
),
-- Add reverse direction matches
bidirectional_matches AS (
    SELECT 
        base_show_id,
        similar_show_id,
        base_date,
        similar_date,
        base_tour,
        similar_tour,
        shared_songs_list,
        shared_count,
        similarity_score,
        tour_similarity,
        year_difference
    FROM final_filtered
    
    UNION ALL
    
    -- Add reverse direction only for high similarity matches
    SELECT 
        similar_show_id as base_show_id,
        base_show_id as similar_show_id,
        similar_date as base_date,
        base_date as similar_date,
        similar_tour as base_tour,
        base_tour as similar_tour,
        shared_songs_list,
        shared_count,
        similarity_score,
        tour_similarity,
        year_difference
    FROM final_filtered
    WHERE similarity_score >= 0.45  -- Only add reverse direction for very similar shows
)
SELECT 
    f.base_show_id,
    f.similar_show_id,
    p.show_date,
    p.venue,
    p.city,
    p.state,
    p.tour_name,
    f.similarity_score,
    f.shared_count as shared_songs,
    f.shared_songs_list,
    f.tour_similarity,
    f.year_difference,
    AVG(p.jam_score) as avg_jam_score,
    sum(f.similarity_score) as score
FROM bidirectional_matches f
JOIN DEV_T3_PRESENTATION.GOOSE_SETS p 
    ON p.show_id = f.similar_show_id
GROUP BY 
    f.base_show_id,
    f.similar_show_id,
    p.show_date,
    p.venue,
    p.city,
    p.state,
    p.tour_name,
    f.similarity_score,
    f.shared_count,
    f.shared_songs_list,
    f.tour_similarity,
    f.year_difference
ORDER BY f.similarity_score DESC