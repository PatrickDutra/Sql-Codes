SELECT
    CONCAT('<a href="', '%%WWWROOT%%/course/view.php?id=', c.id, '">', c.fullname, '</a>') AS 'Link do curso',
    CONCAT('<a href="', '%%WWWROOT%%/mod/forum/view.php?id=', f.id, '">', f.name, '</a>') AS 'Link Fórun',
    MAX(CONCAT('<a href="', '%%WWWROOT%%/mod/forum/discuss.php?d=', fd.id, '">', '%%WWWROOT%%/mod/forum/discuss.php?d=', fd.id, '</a>')) AS 'Link topico',
    p.message AS Mensagem,
    DATE_FORMAT(FROM_UNIXTIME(p.created), '%d/%m/%Y %H:%i:%s') AS 'data criada',
    CONCAT(u.firstname, ' ', u.lastname) AS 'Enternauta'
FROM prefix_forum_posts AS fp
JOIN prefix_user AS u ON u.id = fp.userid
JOIN prefix_user_enrolments AS ue ON ue.userid = u.id
JOIN prefix_enrol AS e ON e.id = ue.enrolid
JOIN prefix_role_assignments AS ra ON ra.userid = u.id
JOIN prefix_role AS r ON r.id = ra.roleid
JOIN prefix_forum_discussions AS fd ON fp.discussion = fd.id
JOIN prefix_forum AS f ON f.id = fd.forum
JOIN prefix_course AS c ON c.id = fd.course
JOIN prefix_course_categories AS ct ON c.category = ct.id
JOIN prefix_forum_posts AS p ON p.id = fp.id
WHERE
    r.shortname = 'student0'
    AND c.id = 1408
  
GROUP BY f.id, u.id, p.message, p.created, u.firstname, u.lastname, fd.timemodified
ORDER BY c.id, fd.timemodified, c.fullname