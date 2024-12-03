MODEL (
    name DEV_T2_EDW.fct_goose_shows,
    kind FULL,
    cron '@monthly',
    grain  show_id
  );
with shows as (select * from DEV_T1_STAGING.stg__goose_shows),
venues as (select * from DEV_T1_STAGING.stg__goose_venues),
c as (select city,state_id,city_ascii, state_name,lat,lng from SEEDS.CITIES),

joined as (
    select 
        s.showid show_id,
        s.city show_city,
        s.state show_state_us,
        s.venue show_venue ,
        s.country show_country,
        cast(s.showdate as date) show_date,
        s.tour_name tour_name,
        s.artist artist,
        v.short_name venue_short_name,
        coalesce(cast(c.lat as text),0) lat,
        coalesce(cast(c.lng as text),0) long   
        from shows s 
left join venues v on s.venueid = v.venueid
  left join c on s.state = c.state_id and (s.city = c.city_ascii or  s.city = c.city)

group by all
)
select * from joined

