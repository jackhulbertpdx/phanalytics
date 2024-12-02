
select
   cast( base_show_id as varchar) base_show_id,
   cast(  similar_show_id as varchar) similar_show_id,
    show_date,
    venue,
    city,
    state,
    tour_name,
    similarity_score,
    shared_songs,
    shared_songs_list,
    tour_similarity,
    year_difference,
    avg_jam_score,
    score
from
GOOSE_SIMILAR_SHOWS