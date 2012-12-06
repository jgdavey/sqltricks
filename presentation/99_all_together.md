!SLIDE[tpl=verbose]

# Find duplicates

    @@@ sql
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
    ), duplicated_schedule_entries(user_id, duplicates) AS (
      SELECT user_id, string_agg( format('%s: %I', type , id), ', ' order by type, id)
      FROM schedules
      GROUP BY user_id
      HAVING count(user_id) > 1
    )
    SELECT id, email, duplicates
    FROM accounts
    INNER JOIN duplicated_schedule_entries d
    ON d.user_id = accounts.id
    ;
