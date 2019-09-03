with new_project as (
	SELECT
		pt.project_number || ' - ' || cr.customer_name || ' - ' || pt.project_name AS "PROJECT_NAME",    
		round(nvl(SUM(wt.end_time - wt.start_time) * 24, 0), 0) AS "CZAS"
	FROM
		project pt
		LEFT JOIN customer cr ON cr.customer_id = pt.customer_id
		join work_time wt ON wt.project_id = pt.project_id
	WHERE
		TO_CHAR(wt.start_time, 'yyyy/MM/dd') >= '2019/03/01'
),
old_project as (
	SELECT
		pt.project_number || ' - ' || cr.customer_name || ' - ' || pt.project_name AS "PROJECT_NAME",    
		round(nvl(SUM(sha.czas_opracowania), 0), 0) AS "CZAS"
	FROM
		project pt
		LEFT JOIN customer cr ON cr.customer_id = pt.customer_id
		join sharepoint_work_time sha ON wt.project_id = pt.project_id
)
SELECT 
	np.PROJECT_NAME as PROJECT_NAME,
	(np.CZAS + op.CZAS) as CZAS
FROM
	new_project np
	FULL JOIN old_project op ON np.PROJECT_NAME=op.PROJECT_NAME
ORDER BY
	2 DESC;
