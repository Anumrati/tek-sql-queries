UPDATE (
    SELECT
        workset_id,
        emp.employee_login,
        mact.main_activity_name,
        aele.activity_element_name,
        asub.activity_subelement_name,
        asoft.activity_software_name
    FROM
        work_time             wt
        LEFT JOIN employee              emp ON emp.employee_id = wt.employee_id
        LEFT JOIN main_activity         mact ON mact.main_activity_id = wt.main_activity_id
        LEFT JOIN activity_element      aele ON aele.activity_element_id = wt.second_activity_id
        LEFT JOIN activity_subelement   asub ON asub.activity_subelement_id = wt.third_activity_id
        LEFT JOIN activity_software     asoft ON asoft.activity_software_id = wt.software_activity_id
    WHERE 
        mact.main_activity_name IS NOT NULL
)
SET
    workset_id = (
        SELECT
            wset.workset_id
        FROM
            workset    wset
            LEFT JOIN activity   act1 ON act1.activity_id = wset.first_activity_id
            LEFT JOIN activity   act2 ON act2.activity_id = wset.second_activity_id
            LEFT JOIN activity   act3 ON act3.activity_id = wset.third_activity_id
            LEFT JOIN activity   act4 ON act4.activity_id = wset.software_id
        WHERE
            ( act1.activity_name = main_activity_name
              AND act2.activity_name IS NULL
              AND act3.activity_name IS NULL
              AND act4.activity_name IS NULL )
            OR ( act1.activity_name = main_activity_name
                 AND act2.activity_name = activity_element_name
                 AND act3.activity_name IS NULL
                 AND act4.activity_name IS NULL )
            OR ( act1.activity_name = main_activity_name
                 AND act2.activity_name = activity_element_name
                 AND act3.activity_name = activity_subelement_name
                 AND act4.activity_name IS NULL )
            OR ( act1.activity_name = main_activity_name
                 AND act2.activity_name = activity_element_name
                 AND act3.activity_name = activity_subelement_name
                 AND act4.activity_name = activity_software_name )
    )