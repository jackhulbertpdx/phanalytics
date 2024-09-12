with 

source as (

    select * from {{ source('phish', 'RAW_PHISH_ARTISTS') }}

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
