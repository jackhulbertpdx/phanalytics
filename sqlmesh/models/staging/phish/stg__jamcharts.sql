MODEL (
    name DEV_T1_STAGING.stg__jamcharts,
    kind FULL,
    cron '@monthly',
    grain  uniqueid

  );



with

source as (

    select * from DEV_T0_RAW.PHISH_JAMCHARTS

),

renamed as (

    select
        gap,
        set,  -- renamed to avoid keyword
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
        _extracted_at
    from source

)

select * from renamed
