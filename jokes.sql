WITH trauma_stats AS (
    SELECT
        date,
        --- their phone number is situationship_id
        situationship_id,
        situationship_name,
        mental_health_rating,
        relationship_potential_rating,
        SUM(crashout_nights) AS total_crashout_nights,
        SUM(minutes_staring_at_ceiling) AS total_time_in_contemplative_pain
    FROM traumaLogs.chris_truong_brain
    WHERE 
        date BETWEEN '2024-01-01' AND CURRENT_DATE()
        AND total_situationships > 0
        AND crashout_nights > 0
        AND baddies_fumbled > 0 
        AND overthinking_mode = 'perpetually on'
        AND mental_health_rating IN ('slightly depressed', 'depressed', 'very depressed')
    GROUP BY ALL
    HAVING relationship_potential_rating > 0
),

productivity_stats AS (
    SELECT
        date,
        ---let's just assume the situationship_id is in productivityLogs
        situationship_id,
        SUM(hours_worked) AS total_hours_worked,
        SUM(chapters_read) AS total_chapters_read,
        SUM(leetcode_problems_completed) AS total_leetcode_problems_completed  
    FROM productivityLogs.chris_truong_brain
    WHERE
        date BETWEEN '2024-01-01' AND CURRENT_DATE()
    GROUP BY ALL
)

SELECT
    a.date,
    a.situationship_id,
    a.situation_name,
    a.mental_health_rating,
    a.relationship_potential_rating,
    SUM(a.total_crashout_nights) AS total_crashout_nights,
    SUM(a.total_time_in_contemplative_pain) AS total_time_in_contemplative_pain,
    SUM(b.hours_worked) AS total_hours_worked,
    SUM(b.total_chapters_read) AS total_chapters_read,
    SUM(b.total_leetcode_problems_completed) AS total_leetcode_problems_completed
FROM trauma_stats AS a
LEFT JOIN productivity_stats AS b USING (date, situationship_id)
GROUP BY ALL
ORDER BY total_time_in_contemplative_pain DESC
;
