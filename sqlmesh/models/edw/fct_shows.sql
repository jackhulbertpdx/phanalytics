MODEL (
    name DEV_T2_EDW.fct_shows,
    kind FULL,
    cron '@monthly',
    grain  show_id
  );
with shows as (select * from DEV_T1_STAGING.stg__shows),
venues as (select * from DEV_T1_STAGING.stg__venues),
joined as (
    select 
        s.showid show_id,
        s.city show_city,
        s.state show_state_us,
        s.venue show_venue ,
        s.country show_country,
        cast(s.showdate as date) show_date,
        s.tour_name tour_name,
        s.artist_name artist,
        s.setlist_notes set_notes,
        v.short_name venue_short_name,
        v.venuenotes venue_notes
from shows s 
left join venues v on s.venueid = v.venueid

group by all
)
select * from joined