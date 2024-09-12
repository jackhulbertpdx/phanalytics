with 

source as (

    select * from DEV_T0_RAW.RAW_PHISH_SETLISTS

),

renamed as (

    select
        gap,
       "SET",
        city,
        meta,
        slug,
        song,
        isjam,
        state,
        venue,
        showid,
        songid,
        tourid,
        country,
        exclude,
        reviews,
        venueid,
        artistid,
        footnote,
        nickname,
        position,
        showdate,
        showyear,
        tourname,
        tourwhen,
        uniqueid,
        isreprise,
        permalink,
        tracktime,
        isjamchart,
        soundcheck,
        trans_mark,
        transition,
        artist_name,
        artist_slug,
        is_original,
        setlistnotes,
        jamchart_description,
        _airbyte_extracted_at

    from source

)

select * from renamed
