SELECT
    CONCAT(u.firstname, ' ', u.lastname) AS NomeDoAluno,
    c.fullname AS NomeDoCurso,
    JSON_UNQUOTE(JSON_EXTRACT(uid_cid.data, '$.localidade')) AS localidade,
    FROM_UNIXTIME(MAX(ul.timeaccess)) AS UltimoAcesso,
    MAX(CASE WHEN s.name = 'Módulo 01' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_01,
    MAX(CASE WHEN s.name = 'Módulo 02' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_02,
    MAX(CASE WHEN s.name = 'Módulo 03' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_03,
    MAX(CASE WHEN s.name = 'Módulo 04' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_04,
    MAX(CASE WHEN s.name = 'Módulo 05' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_05,
    MAX(CASE WHEN s.name = 'Módulo 06' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_06,
    MAX(CASE WHEN s.name = 'Módulo 07' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_07,
    MAX(CASE WHEN s.name = 'Módulo 08' THEN CONCAT(FLOOR(total_atividades.PorcentagemDeAtividadesConcluidas), '%') ELSE NULL END) AS Módulo_08
FROM
    mdl_user_enrolments ue
JOIN
    mdl_user u ON ue.userid = u.id
JOIN
    mdl_enrol e ON ue.enrolid = e.id
JOIN
    mdl_course c ON e.courseid = c.id
JOIN
    mdl_course_sections s ON s.course = c.id
LEFT JOIN
    mdl_course_modules cm ON cm.section = s.id
LEFT JOIN
    mdl_course_modules_completion cmpl ON cmpl.coursemoduleid = cm.id AND cmpl.userid = u.id
LEFT JOIN
    mdl_user_lastaccess ul ON ul.courseid = c.id AND ul.userid = u.id
LEFT JOIN
(
    SELECT
        s.id AS section_id,
        u.id AS user_id,
        (COUNT(DISTINCT cm.id) * 100.0 / total_atividades.TotalDeAtividadesNaSection) AS PorcentagemDeAtividadesConcluidas
    FROM
        mdl_course_sections s
    JOIN
        mdl_course_modules cm ON cm.section = s.id
    LEFT JOIN
        mdl_course_modules_completion cmpl ON cmpl.coursemoduleid = cm.id
    LEFT JOIN
        mdl_user u ON cmpl.userid = u.id
    JOIN
    (
        SELECT
            s.id AS section_id,
            COUNT(DISTINCT cm_inner.id) AS TotalDeAtividadesNaSection
        FROM
            mdl_course_sections s
        JOIN
            mdl_course_modules cm_inner ON cm_inner.section = s.id
        LEFT JOIN
            mdl_course_modules_completion cmpl_inner ON cmpl_inner.coursemoduleid = cm_inner.id
        WHERE
            cm_inner.module <> 0
           
           
           
           
           
           
            AND (cmpl_inner.completionstate = 1 OR cmpl_inner.completionstate = 2)
        GROUP BY
            s.id
    ) total_atividades ON s.id = total_atividades.section_id
    WHERE
        s.course = 1408 -- Filtrando pelo curso 1408
    GROUP BY
        s.id, u.id
) total_atividades ON s.id = total_atividades.section_id AND u.id = total_atividades.user_id
LEFT JOIN (
    SELECT
        u.id,
        uid.data
    FROM
        mdl_user AS u
    JOIN
        mdl_user_info_data AS uid ON uid.userid = u.id
    JOIN
        mdl_user_info_field AS uif ON uid.fieldid = uif.id AND uif.shortname = 'cepbrasil'
) AS uid_cid ON u.id = uid_cid.id
WHERE
    c.id = 1408 -- Filtrando pelo curso 1408
GROUP BY
    u.id, c.fullname, uid_cid.data
ORDER BY
    NomeDoAluno, NomeDoCurso
