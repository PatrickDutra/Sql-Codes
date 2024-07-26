SELECT
    CONCAT(u.firstname, ' ', u.lastname) AS nome_completo,
    u.email,
    DATE_FORMAT(FROM_UNIXTIME(MAX(ul.timeaccess)), '%d/%m/%Y') AS ultimo_acesso,
    uid_tel.data AS telefone,
    DATE_FORMAT(FROM_UNIXTIME(uid_nasc.data), '%d/%m/%Y') AS data_nascimento,
    JSON_UNQUOTE(JSON_EXTRACT(uid_cid.data, '$.localidade')) AS localidade,
    GROUP_CONCAT(DISTINCT r.name SEPARATOR ', ') AS papeis,
    GROUP_CONCAT(DISTINCT c.fullname ORDER BY c.fullname ASC) AS CursosMatriculados
FROM
    prefix_user AS u
JOIN
    prefix_role_assignments AS ra ON u.id = ra.userid
JOIN
    prefix_context AS cxt ON ra.contextid = cxt.id
left JOIN
    prefix_role AS r ON ra.roleid = r.id
JOIN
    prefix_course AS c ON cxt.instanceid = c.id
left JOIN
    prefix_enrol AS e ON c.id = e.courseid
left JOIN
    prefix_user_enrolments AS ue ON e.id = ue.enrolid AND u.id = ue.userid
LEFT JOIN
    prefix_user_lastaccess AS ul ON u.id = ul.userid
LEFT JOIN (
    SELECT
        u.id,
        uid.data
    FROM
        prefix_user AS u
    JOIN
        prefix_user_info_data AS uid ON uid.userid = u.id
    JOIN
        prefix_user_info_field AS uif ON uid.fieldid = uif.id AND uif.shortname = 'celular'
) AS uid_tel ON u.id = uid_tel.id
LEFT JOIN (
    SELECT
        u.id,
        uid.data
    FROM
        prefix_user AS u
    JOIN
        prefix_user_info_data AS uid ON uid.userid = u.id
    JOIN
        prefix_user_info_field AS uif ON uid.fieldid = uif.id AND uif.shortname = 'datanasc'
) AS uid_nasc ON u.id = uid_nasc.id
LEFT JOIN (
    SELECT
        u.id,
        uid.data
    FROM
        prefix_user AS u
    JOIN
        prefix_user_info_data AS uid ON uid.userid = u.id
    JOIN
        prefix_user_info_field AS uif ON uid.fieldid = uif.id AND uif.shortname = 'cepbrasil'
) AS uid_cid ON u.id = uid_cid.id
WHERE c.id = 1408
AND r.shortname = "student0"
GROUP BY
    u.id,
    nome_completo,
    email,
    telefone,
    data_nascimento,
    localidade
ORDER BY CursosMatriculados, nome_completo