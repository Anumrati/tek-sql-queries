WITH new_project AS (
    SELECT
        pt.project_number,
        round(nvl(SUM(wt.end_time - wt.start_time) * 24, 0), 0) AS "CZAS"
    FROM
        project     pt
        INNER JOIN work_time   wt ON wt.project_id = pt.project_id
    WHERE
        to_char(wt.start_time, 'yyyy/MM/dd') >= '2019/03/01'
    GROUP BY
        pt.project_number
), old_project AS (
    SELECT
        pt.project_number,
        round(nvl(SUM(sha.czas_opracowania), 0), 0) AS "CZAS"
    FROM
        project                pt
        INNER JOIN sharepoint_work_time   sha ON sha.id_projekty_tek = pt.project_id
    GROUP BY
        pt.project_number
)
SELECT
    pt.project_number
    || ' - '
    || cr.customer_name
    || ' - '
    || pt.project_name AS "PROJECT_NAME",
    ( nvl(np.czas,0) + nvl(op.czas,0) ) AS "CZAS"
FROM
    project       pt
    LEFT JOIN customer      cr ON cr.customer_id = pt.customer_id
    LEFT JOIN new_project   np ON pt.project_number = np.project_number
    LEFT JOIN old_project   op ON pt.project_number = op.project_number
ORDER BY
    2 DESC;
