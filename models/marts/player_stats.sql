with players as (
    select * from {{ ref('stg_players') }}
),

teams as (
    select * from {{ ref('stg_teams') }}
),

goals as (
    select * from {{ ref('stg_goals') }}
),

player_goals as (
    select
        player_id,
        count(*) as total_goals,
        sum(case when is_penalty then 1 else 0 end) as penalty_goals,
        count(*) - sum(case when is_penalty then 1 else 0 end) as open_play_goals,
        min(minute) as earliest_goal_minute,
        round(avg(minute)) as avg_goal_minute
    from goals
    where not is_own_goal
    group by player_id
)

select
    players.player_id,
    players.player_name,
    players.position,
    players.nationality,
    teams.team_name,
    teams.short_name as team_short_name,
    coalesce(player_goals.total_goals, 0) as total_goals,
    coalesce(player_goals.penalty_goals, 0) as penalty_goals,
    coalesce(player_goals.open_play_goals, 0) as open_play_goals,
    player_goals.earliest_goal_minute,
    player_goals.avg_goal_minute
from players
left join teams on players.team_id = teams.team_id
left join player_goals on players.player_id = player_goals.player_id
