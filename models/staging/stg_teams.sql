select
    team_id,
    team_name,
    short_name,
    stadium,
    city
from {{ ref('raw_teams') }}
