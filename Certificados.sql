SELECT DISTINCT 
    CONCAT(u.firstname, ' ', u.lastname) AS 'Enternauta',
    c.fullname AS Curso,
    t.name AS 'Nome do Certificado',
    FROM_UNIXTIME(i.timecreated) AS data_do_certificado,
    CASE WHEN i.id IS NOT NULL THEN 'Sim' ELSE 'Não' END AS 'Conseguiu Certificado'
FROM
    prefix_user u
JOIN
    prefix_user_enrolments ue ON u.id = ue.userid
JOIN
    prefix_enrol e ON ue.enrolid = e.id
JOIN
    prefix_course c ON e.courseid = c.id
LEFT JOIN
    prefix_tool_certificate_issues i ON i.userid = u.id AND i.courseid = c.id
LEFT JOIN
    prefix_tool_certificate_templates t ON i.templateid = t.id
JOIN
    prefix_role_assignments ra ON u.id = ra.userid
JOIN
    prefix_role r ON ra.roleid = r.id
WHERE
    c.id = 1408
	AND CONCAT(u.firstname, ' ', u.lastname) NOT IN ('Gabriel Dornelles', 'Patrick Dutra', 'Ana Caroline Longhi Ozelame', 'Juliana Carolina Provenzi')
ORDER BY
   'Enternauta', 'Nome do Certificado'