with 

source as (

    select * from DEV_T0_RAW.RAW_PHISH_SHOWS

),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta,
        city,
        state,
        venue,
        showid,
        tourid,
        country,
        showday,
        venueid,
        artistid,
        showdate,
        showyear,
        permalink,
        showmonth,
        tour_name,
        created_at,
        updated_at,
        artist_name,
        setlist_notes,
        exclude_from_stats

    from source

)

select * from renamed
