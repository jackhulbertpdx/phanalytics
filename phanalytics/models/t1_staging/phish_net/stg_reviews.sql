with 

source as (

    select * from DEV_T0_RAW.RAW_PHISH_REVIEWS

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
