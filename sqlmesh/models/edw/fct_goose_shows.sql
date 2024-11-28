MODEL (
    name DEV_T2_EDW.fct_goose_shows,
    kind FULL,
    cron '@daily',
    grain  show_id
  );
with shows as (select * from DEV_T1_STAGING.stg__goose_shows),
venues as (select * from DEV_T1_STAGING.stg__goose_venues),
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
        v.short_name venue_short_name
        from shows s 
left join venues v on s.venueid = v.venueid

group by all
)
select * from joined

