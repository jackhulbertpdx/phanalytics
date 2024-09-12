with 

source as (

    select * from DEV_T0_RAW.RAW_PHISH_VENUES

),

renamed as (

    select
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta,
        city,
        alias,
        state,
        country,
        venueid,
        venuename,
        short_name,
        venuenotes

    from source

)

select * from renamed
