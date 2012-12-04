WITH schedules(user_id, type, id, created_at) AS (
  select user_id, 'weekly', id, created_at from weekly_schedules
  UNION ALL
  select user_id, 'biweekly', id, created_at from biweekly_schedules
  UNION ALL
  select user_id, 'particular', id, created_at from particular_day_schedules
  UNION ALL
  select user_id, 'twice_monthly', id, created_at from twice_monthly_schedules
  UNION ALL
  select user_id, 'manual', id, created_at from manual_schedules
)
SELECT DISTINCT ON(user_id) user_id, id, type, created_at
FROM schedules
ORDER BY user_id, created_at
;
