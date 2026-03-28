with teams as (
    select * from {{ ref('stg_teams') }}
),

matches as (
    select * from {{ ref('stg_matches') }}
),

home_stats as (
    select
        home_team_id as team_id,
        count(*) as played,
        sum(case when result = 'home_win' then 1 else 0 end) as wins,
        sum(case when result = 'draw' then 1 else 0 end) as draws,
        sum(case when result = 'away_win' then 1 else 0 end) as losses,
        sum(home_goals) as goals_for,
        sum(away_goals) as goals_against
    from matches
    group by home_team_id
),

away_stats as (
    select
        away_team_id as team_id,
        count(*) as played,
        sum(case when result = 'away_win' then 1 else 0 end) as wins,
        sum(case when result = 'draw' then 1 else 0 end) as draws,
        sum(case when result = 'home_win' then 1 else 0 end) as losses,
        sum(away_goals) as goals_for,
        sum(home_goals) as goals_against
    from matches
    group by away_team_id
),

combined as (
    select
        team_id,
        sum(played) as matches_played,
        sum(wins) as wins,
        sum(draws) as draws,
        sum(losses) as losses,
        sum(goals_for) as goals_for,
        sum(goals_against) as goals_against,
        sum(goals_for) - sum(goals_against) as goal_difference,
        sum(wins) * 3 + sum(draws) as points
    from (
        select * from home_stats
        union all
        select * from away_stats
    ) all_stats
    group by team_id
)

select
    teams.team_id,
    teams.team_name,
    teams.short_name,
    teams.stadium,
    teams.city,
    coalesce(combined.matches_played, 0) as matches_played,
    coalesce(combined.wins, 0) as wins,
    coalesce(combined.draws, 0) as draws,
    coalesce(combined.losses, 0) as losses,
    coalesce(combined.goals_for, 0) as goals_for,
    coalesce(combined.goals_against, 0) as goals_against,
    coalesce(combined.goal_difference, 0) as goal_difference,
    coalesce(combined.points, 0) as points
from teams
left join combined on teams.team_id = combined.team_id
