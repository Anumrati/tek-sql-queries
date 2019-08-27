SELECT
    pt.project_number,
    pt.project_name,
    ( (
        SELECT
            round(nvl(SUM(wt.end_time - wt.start_time) * 24, 0), 0)
        FROM
            work_time wt
        WHERE
            TO_CHAR(wt.start_time, 'yyyy/MM/dd') >= '2019/03/01'
            AND wt.project_id = pt.project_id
    ) + (
        SELECT
            round(nvl(SUM(sha.czas_opracowania), 0), 0)
        FROM
            sharepoint_work_time sha
        WHERE
            sha.id_projekty_tek = pt.project_id
    ) ) AS "CZAS"
FROM
    project pt
ORDER BY
    "CZAS" DESC;