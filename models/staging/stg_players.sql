select
    player_id,
    team_id,
    player_name,
    position,
    nationality
from {{ ref('raw_players') }}
