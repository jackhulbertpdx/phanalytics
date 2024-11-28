
select
    base_show_id,
    similar_show_id,
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