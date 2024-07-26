SELECT 
    c.fullname AS NomeDoCurso,
    CONCAT(u.firstname, ' ', u.lastname) AS NomeDoAluno,
    COUNT(DISTINCT cm.id) AS QuantidadeDeAtividades,
    total_atividades.TotalDeAtividadesNoCurso,
    ROUND((COUNT(DISTINCT cm.id) * 100.0 / total_atividades.TotalDeAtividadesNoCurso), 2) AS PorcentagemDeAtividadesConcluidas,
    MAX(uid_tel.data) AS telefone,
    CONCAT('https://wa.me/', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(MAX(uid_tel.data), '(', ''), ')', ''), '-', ''), ' ', ''), '+', '')) AS link_whatsapp,
    DATE_FORMAT(FROM_UNIXTIME(MAX(ul.timeaccess)), '%d/%m/%Y') AS ultimo_acesso,
    subquery.questionnairename AS Encontro,
    subquery.name AS feedback,
    subquery.content AS nota_encontro

FROM
    prefix_course AS c
JOIN
    prefix_course_modules AS cm ON c.id = cm.course
JOIN
    prefix_course_modules_completion AS cmpl ON cmpl.coursemoduleid = cm.id
JOIN
    prefix_user AS u ON cmpl.userid = u.id
JOIN
    (SELECT 
        c.id AS course_id,
        COUNT(DISTINCT cm_inner.id) AS TotalDeAtividadesNoCurso
    FROM
        prefix_course AS c
    JOIN
        prefix_course_modules AS cm_inner ON c.id = cm_inner.course
    LEFT JOIN
        prefix_course_modules_completion AS cmpl_inner ON cmpl_inner.coursemoduleid = cm_inner.id
    WHERE
        cm_inner.module <> 0
        AND cm_inner.visible = 1
        AND (cmpl_inner.completionstate = 1 OR cmpl_inner.completionstate = 2) -- Concluído ou em progresso
    GROUP BY
        c.id
    ) AS total_atividades ON c.id = total_atividades.course_id
LEFT JOIN (
    SELECT 
        c.fullname AS course,
        CONCAT(vu.firstname, ' ', vu.lastname) AS Fullname,
        q.name AS questionnairename,
        qq.name,
        qqc.content,
        FROM_UNIXTIME(qr.submitted) AS submitted
    FROM 
        prefix_questionnaire_resp_single AS qrs
    JOIN 
        prefix_questionnaire_question AS qq ON qq.id = qrs.question_id
    JOIN 
        prefix_questionnaire_quest_choice AS qqc ON qqc.id = qrs.choice_id
    JOIN 
        prefix_questionnaire_response AS qr ON qr.id = qrs.response_id
    JOIN 
        prefix_user AS vu ON vu.id = qr.userid
    JOIN 
        prefix_questionnaire AS q ON q.id = qr.questionnaireid
    JOIN 
        prefix_course AS c ON c.id = q.course
    WHERE 
        (qq.name LIKE '%fb_conteudo%' OR qq.name LIKE '%fb_emocional%')
        AND c.id = 1382
        AND qr.submitted >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 15 DAY))
) AS subquery ON c.fullname = subquery.course AND CONCAT(u.firstname, ' ', u.lastname) = subquery.Fullname
LEFT JOIN (
    SELECT 
        u.id,
        MAX(uid.data) AS data
    FROM 
        prefix_user AS u
    JOIN 
        prefix_user_info_data AS uid ON uid.userid = u.id
    JOIN 
        prefix_user_info_field AS uif ON uid.fieldid = uif.id AND uif.shortname = 'celular'
    GROUP BY
        u.id
) AS uid_tel ON uid_tel.id = u.id
LEFT JOIN prefix_user_lastaccess AS ul ON ul.userid = u.id
WHERE
    cm.module <> 0
    AND cm.visible = 1
    AND c.id = 1382
GROUP BY
    c.fullname, u.id, total_atividades.TotalDeAtividadesNoCurso, subquery.questionnairename, subquery.name, subquery.content, subquery.submitted
ORDER BY
    c.fullname, NomeDoAluno
