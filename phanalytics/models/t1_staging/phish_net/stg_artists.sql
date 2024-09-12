with 

source as (

    select * from DEV_T0_RAW.RAW_PHISH_ARTISTS

),

renamed as (

    select
        id,
        slug,
        artist,
        _airbyte_extracted_at

    from source

)

select * from renamed