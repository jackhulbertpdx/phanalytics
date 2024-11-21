MODEL (
    name DEV_T3_PRESENTATION.PHISH_REVIEWS,
    kind FULL,
    cron '@daily',
    grain review_id
  );

with 

source as (

    select * from DEV_T2_EDW.FCT_REVIEWS

),

renamed as (

    select
        user_id,
        show_city,
        case
        when
        cast(rating_score as integer)<0 then 0
        when cast(rating_score as integer)>5 then 5
        else rating_score 
        end
        rating_score,
        show_state,
        show_venue,
        show_id,
        show_country,
         artist_id,
         review_id,
        show_date,
         posted_at,
        artist_name,
        review_text
    from source

)

select * from renamed
