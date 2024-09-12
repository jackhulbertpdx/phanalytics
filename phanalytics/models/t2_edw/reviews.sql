with 

source as (

    select * from {{ ref('stg_reviews') }}

),

renamed as (

    select
        uid user_id,
        city show_city,
        score rating_score,
        state show_state,
        venue show_venue,
        showid show_id,
        country show_country,
        artistid artist_id,
        reviewid review_id,
        cast( showdate  as date) show_date,
        cast( posted_at  as date) posted_at,
        artist_name,
        review_text
    from source

)

select * from renamed
