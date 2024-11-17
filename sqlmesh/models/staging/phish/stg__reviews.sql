MODEL (
    name DEV_T1_STAGING.stg__reviews,
    kind FULL,
    cron '@daily',
    grain  uid
  );



with 

source as (

    select * from DEV_T0_RAW.PHISH_REVIEWS

),

renamed as (

    select
        uid,
        city,
        score,
        state,
        venue,
        showid,
        country,
        artistid,
        reviewid,
        showdate,
        showyear,
        username,
        permalink,
        posted_at,
        artist_name,
        review_text,
        _airbyte_extracted_at

    from source

)

select * from renamed
