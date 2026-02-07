MODEL (
    name DEV_T2_EDW.fct_goose_sets,
    kind FULL,
    cron '@monthly',
    grain  set_id
  );


with 
sets as (select * from DEV_T1_STAGING.STG__GOOSE_SETLISTS),
c as (select city,state_id,city_ascii, state_name,lat,lng from SEEDS.CITIES),
joined as (
    select 
        cast(s.uniqueid as varchar) as set_id,
        cast(s.song as varchar) song_name ,
        cast(s.position as varchar) as sequence,
        cast(s.venuename as varchar) show_venue,
        cast(s.show_id as varchar) as show_id,
        cast(s.song_id as varchar) as song_id ,
        cast(s.tour_id as varchar) as tour_id,
        cast(s.country as varchar) country,
        cast(s.venue_id as varchar) as venue_id,
        cast(s.artistid as varchar) as artist_id,
        cast(s.showdate as date) as show_date,
        (s.tracktime ) track_time,
        cast(s.artist_name as varchar) artist,
        cast(tourname as varchar) as tour_name,
        cast(Case when s.is_original=0 then FALSE ELSE TRUE END as boolean) is_original,
        cast(coalesce(c.city,s.city) as varchar) as show_city,
        cast(case when coalesce(c.state_id,s.state) is null then 'Unknown' else coalesce(c.state_id,s.state) end as varchar) show_state,
        CASE show_state
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AK' THEN 'Alaska'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'ME' THEN 'Maine'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MS' THEN 'Mississippi'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NE' THEN 'Nebraska'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NH' THEN 'New Hampshire'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NY' THEN 'New York'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'SD' THEN 'South Dakota'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VT' THEN 'Vermont'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WV' THEN 'West Virginia'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WY' THEN 'Wyoming'
        ELSE 'Unknown'
    END AS state_name,
    'goose' as source,
        coalesce(cast(c.lat as text),0) lat,
        coalesce(cast(c.lng as text),0) long        from sets s 
        left join c on s.state = c.state_id and (s.city = c.city_ascii or  s.city = c.city) )
select * from joined