with source as (
      select * from {{ source('phish', 'RAW_PHISH_ARTISTS') }}
),
renamed as (
    select
        

    from source
)
select * from renamed
  