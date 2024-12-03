MODEL (
    name DEV_T2_EDW.fct_sets,
    kind FULL,
    cron '@monthly',
    grain  set_id
  );


with 
sets as (select * from DEV_T1_STAGING.STG__SETLISTS),
c as (select city,state_id,city_ascii, state_name,lat,lng from SEEDS.CITIES),
joined as (
    select 
        s.uniqueid as set_id,
        s.song song_name ,
        case when s.isjam=0 then FALSE ELSE TRUE END is_jam,
        s.position as sequence,
        s.venue show_venue,
        s.showid show_id,
        s.songid song_id ,
        s.tourid tour_id,
        s.country show_country,
        s.reviews set_review,
        s.venueid venue_id,
        s.artistid artist_id,
        s.footnote set_footnote,
        s.nickname set_nickname,
        cast(s.showdate as date) show_date,
        s.tourname tour_name,
        Case when s.isreprise=0 then FALSE ELSE TRUE END is_reprise,
        s.tracktime track_time,
        Case when s.isjamchart=0 then FALSE ELSE TRUE END is_jamchart,
        s.soundcheck soundcheck,
        s.artist_name,
        s.artist_slug,
        Case when s.is_original=0 then FALSE ELSE TRUE END is_original,
        s.setlistnotes set_notes,
        s.jamchart_description,
        coalesce(c.city,s.city) as show_city,
        case when coalesce(c.state_id,s.state) is null then 'Unknown' else coalesce(c.state_id,s.state) end show_state,
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
        coalesce(cast(c.lat as text),0) lat,
        coalesce(cast(c.lng as text),0) long        from sets s 
        left join c on s.state = c.state_id and (s.city = c.city_ascii or  s.city = c.city) )
select * from joined 
