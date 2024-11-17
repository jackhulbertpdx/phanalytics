MODEL (
    name DEV_T2_EDW.fct_reviews,
    kind FULL,
    cron '@daily',
    grain  uid
  );
with 

source as (

    select * from DEV_T1_STAGING.stg__reviews

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
