select
    match_id,
    matchday,
    match_date,
    home_team_id,
    away_team_id,
    home_goals,
    away_goals,
    case
        when home_goals > away_goals then 'home_win'
        when home_goals < away_goals then 'away_win'
        else 'draw'
    end as result
from {{ ref('raw_matches') }}
