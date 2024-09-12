with source as (
      select * from {{ source('PHISH', 'RAW_PHISH_ARTISTS') }}
),
renamed as (
    select
        

    from source
)
select * from renamed
  