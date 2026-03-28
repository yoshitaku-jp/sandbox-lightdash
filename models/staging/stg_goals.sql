select
    goal_id,
    match_id,
    player_id,
    team_id,
    minute,
    is_penalty,
    is_own_goal
from {{ ref('raw_goals') }}
