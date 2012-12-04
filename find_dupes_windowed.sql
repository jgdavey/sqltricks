WITH schedules(id, user_id, type, created_at) AS (
  select id, user_id, 'weekly', created_at from weekly_schedules
  UNION ALL
  select id, user_id, 'biweekly', created_at from biweekly_schedules
  UNION ALL
  select id, user_id, 'particular', created_at from particular_day_schedules
  UNION ALL
  select id, user_id, 'twice_monthly', created_at from twice_monthly_schedules
  UNION ALL
  select id, user_id, 'manual', created_at from manual_schedules
), duplicated_schedule_entries(id, type, user_id, count) AS (
  SELECT id, type, user_id, count(user_id) OVER (PARTITION BY user_id)
  FROM schedules
)
SELECT user_id, id, type, count
FROM duplicated_schedule_entries
WHERE count > 1
;
