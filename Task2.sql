/*1. Вывести несколькими способами все имена и фамилии студентов, средний балл которых от 3 до 4.*/
Select s.name, s.surname, s.score
From students s
where s.score >= 3 and s.score <= 4;

Select s.name, s.surname, s.score
From students s
where s.score between 3 and 4;

Select s.name, s.surname, s.score
From students s
where s.score in (3, 4);

/*2. Вывести несколькими способами всех студентов заданного курса*/
Select s.*
From students s
where s.n_group >= 2000 and s.n_group <= 3000;

Select s.*
From students s
where substr(s.n_group,1,1) = 2;

/*3. Вывести студентов, которые родились в 21 веке*/
Select s.*
from students s
where s.date_birth >= '2000.01.01';

/*4. Аналогично п.3 вывести всех студентов, которые родились в заданном месяце*/
Select s.*
from students s
where month(s.date_birth) = 4;

/*5. Вывести всех студентов, которые родились в текущем месяце*/
Select s.*
from students s
where month(s.date_birth) = month(curdate());

/*6. Вывести всех студентов и отсортировать по номеру группы*/
Select s.*
From students s
Order by s.n_group;

/*7. Вывести всех студентов и отсортировать по номеру группы, внутри каждой группы отсортировать по фамилии от а до я*/
Select s.*
From students s
Order by s.n_group, s.surname asc;

/*8. Вывести студентов, средний балл которых больше 4 и отсортировать по баллу от большего к меньшему*/
Select s.*
From students s
Where s.score >= 4
Order by s.score;

/*9. Из запроса №8 вывести несколькими способами на экран только 5 студентов с максимальным баллом*/
SELECT s.*
FROM students s
ORDER BY s.score desc
Limit 5;

/*10. Выведите хобби и с использованием условного оператора сделайте риск словами:*/
SELECT s.surname, s.score,
 CASE
 WHEN s.score >= 4 THEN 'очень высокий'
 WHEN s.score >= 3 and s.score < 4 THEN 'высокий'
 WHEN s.score >= 2 and s.score < 3 THEN 'средний'
 WHEN s.score >= 1 and s.score < 2 THEN 'низкий'
 WHEN s.score < 0 THEN 'очень низкий'
 ELSE 'ошибка'
END
FROM students s;

/*Групповые функции*/
/*1. Выведите на экран номера групп и количество студентов, обучающихся в них*/
SELECT s.N_GROUP, COUNT(*)
FROM students s
GROUP BY s.N_GROUP
ORDER BY s.N_GROUP;

/*2. Выведите на экран для каждой группы максимальный средний балл*/
SELECT s.N_GROUP, max(s.score)
FROM students s
GROUP BY s.N_GROUP;

/*3. Подсчитать количество студентов с каждой фамилией*/
SELECT s.surname, Count(s.surname)
FROM students s
GROUP BY s.surname;

/*5. Для студентов каждого курса подсчитать средний балл*/
SELECT substr(s.n_group, 1, 1), avg(s.score) 
FROM students s
GROUP BY substr(s.n_group, 1, 1);

/*6. Для студентов заданного курса вывести один номер групп с максимальным средним баллом*/
SELECT s.N_GROUP, max(s.score)
FROM students s
where substr(s.n_group, 1, 1) = '2'
GROUP BY s.n_group
order by max(s.score)
limit 1;

/*7. Для каждой группы подсчитать средний балл, 
вывести на экран только те номера групп и их средний балл, в которых он менее или равен 3.5.
Отсортировать по от меньшего среднего балла к большему.*/
SELECT s.N_GROUP, s.score
FROM students s
GROUP BY s.N_GROUP
HAVING s.score <= 3.5
Order by s.score asc;

/*8. Вывести 3 хобби с максимальным риском*/
SELECT h.*
FROM hobbies h
ORDER BY h.risk
Limit 3;

/*9. Для каждой группы в одном запросе вывести количество студентов, 
максимальный балл в группе, средний балл в группе, минимальный балл в группе*/
SELECT s.N_GROUP, count(s.N_GROUP), max(s.score), s.score, min(s.score)
FROM students s
GROUP BY s.N_GROUP;

/*10. Вывести студента/ов, который/ые имеют наибольший балл в заданной группе*/
SELECT s.surname, s.score, s.N_GROUP
FROM students s
Where s.n_group = 2253
GROUP BY s.N_GROUP
Having max(s.score);

/*11. Аналогично 10 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом.*/
SELECT s.surname, s.score, s.N_GROUP
FROM students s
GROUP BY s.N_GROUP
Having max(s.score);

/*Многотабличные запросы*/
/*1. Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.*/

select s.name, s.surname, h.name
from students s
inner join students_hobbies sh on s.n_z = sh.n_z
inner join hobbies h on sh.HOBBY_ID = h.id

/*Выведет и тех студентов, у которых нет никаких хобби. 
Правое вхождение будет эквивалентно обычному внутреннему, так как присутствует внешний ключ*/
select *
from students
left join students_hobbies on students.N_Z = students_hobbies.N_Z;

/*2. Вывести информацию о студенте, занимающимся хобби самое продолжительное время.*/
Select S.*,
case
	when sh.DATE_FINISH IS NULL then Datediff(Now(), sh.date_start)
	else Datediff(sh.date_finish, sh.date_start)
end as Date_Finish
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
ORDER BY Date_Finish desc
Limit 1;

/*3. Вывести имя, фамилию, номер зачетки и дату рождения для студентов, 
средний балл которых выше среднего, 
а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.*/
SELECT S.NAME, S.SURNAME,S.N_Z, S.DATE_BIRTH, t1.risksum
FROM STUDENTS S,
	(
        SELECT sh.n_z, sum(h.risk) AS risksum
        FROM students_hobbies sh
        INNER JOIN hobbies h ON sh.hobby_id = h.id
        GROUP BY sh.n_z
    ) t1
WHERE s.n_z = t1.n_z AND t1.risksum > 9 and s.score >= (select avg(s1.score) from students s1);

/*4. Вывести фамилию, имя, зачетку, дату рождения, 
название хобби и длительность в месяцах, для всех завершенных хобби.*/
Select S.NAME, S.SURNAME, S.N_Z, H.NAME, TIMESTAMPDIFF(month, sh.date_start, sh.date_finish)
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
where sh.DATE_FINISH IS NOT NULL;

/*5. Вывести фамилию, имя, зачетку, дату рождения студентов, 
которым исполнилось N полных лет на текущую дату, и которые имеют более 1 действующего хобби.*/ 
Select S.NAME, S.SURNAME, S.N_Z, S.DATE_BIRTH
From STUDENTS S 
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
where TIMESTAMPDIFF(year, s.DATE_BIRTH, Now()) = '21' and SH.DATE_FINISH is null
group by S.NAME, S.SURNAME, S.N_Z, S.DATE_BIRTH
having count(*) > 1;

/*6. Найти средний балл в каждой группе, учитывая только баллы студентов, 
которые имеют хотя бы одно действующее хобби.*/ 
Select N_GROUP, AVG(SCORE)
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
where SH.DATE_FINISH is NULL
GROUP by N_GROUP;

/*7. Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих,
указав номер зачетки студента и номер его группы.*/
Select S.N_Z, S.N_GROUP, H.NAME, H.RISK, Datediff(sh.date_finish, sh.date_start) as Amount
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
where sh.DATE_FINISH IS not NULL and sh.date_start is not null
ORDER BY Amount desc
Limit 1;

/*8. Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.*/ 
Select S.NAME, S.SURNAME, H.NAME as Hobbie, S.SCORE
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
where S.SCORE = (Select MAX(SCORE) From STUDENTS);

/*9. Найти все действующие хобби, которыми увлекаются троечники 2-го курса.*/ 
Select S.NAME, S.SURNAME, H.NAME as Hobbie, S.SCORE, S.N_GROUP
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
where S.SCORE>=3 and s.score<=4 and s.n_group>=2000 and s.n_group<3000 and SH.DATE_FINISH is null;

/*10. Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.*/ 


/*11. Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.*/
Select *
From (Select N_GROUP, COUNT(*) as avg_count From STUDENTS Group by N_GROUP) t1
INNER JOIN (Select N_GROUP, COUNT(*) as inner_count From STUDENTS Where SCORE >= 4 
Group by N_GROUP) t2 on t2.N_GROUP = t1.N_GROUP
where t2.inner_count/t1.avg_count >= 0.6;

/*12. Для каждого курса подсчитать количество различных действующих хобби на курсе.*/
select substr(S.N_GROUP,1,1), Count(distinct sh.hobby_id), 
from students s
INNER JOIN STUDENTS_HOBBIES SH ON S.N_Z = SH.N_Z
group by substr(S.N_GROUP,1,1)
where sh.date_start in not null and sh.date_finish is null;

/*13. Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. 
Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.*/
Select S.N_Z, S.SURNAME, S.NAME, S.DATE_BIRTH, substr(S.N_GROUP,1,1)
From STUDENTS S
LEFT JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
where S.SCORE > 4 and  SH.date_start is null
order by substr(S.N_GROUP,1,1) asc, s.score desc;

/*14. Создать представление, в котором отображается вся информация о студентах, 
которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.*/
CREATE VIEW v1 AS
SELECT S.*
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH ON S.N_Z = SH.N_Z
WHERE sh.date_finish IS NULL AND TIMESTAMPDIFF(YEAR, sh.date_start, Now()) >= 5;

/*15. Для каждого хобби вывести количество людей, которые им занимаются.*/
Select  h.name,Count(*)
From hobbies h
inner join students_hobbies sh on sh.hobby_id = h.id
group by h.id;

/*16. Вывести ИД самого популярного хобби.*/
Select h.id
From hobbies h
inner join students_hobbies sh on sh.hobby_id = h.id
group by h.id
order by Count(*) desc
limit 1;

/*17.  Вывести всю информацию о студентах, занимающихся самым популярным хобби.*/
select s.*
from students s
inner join students_hobbies sh on s.n_z = sh.n_z
inner join (Select h.id as maxId
From hobbies h
inner join students_hobbies sh on sh.hobby_id = h.id
group by h.id
order by Count(*) desc
limit 1) t1 on sh.hobby_id = t1.maxId;


/*18. Вывести ИД 3х хобби с максимальным риском.*/
Select h.id, H.RISK
From HOBBIES H 
ORDER by RISK desc 
Limit 3;

/*19. Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.*/
Select  s.*, case 
when sh.date_finish is not null then Datediff(sh.date_finish, sh.date_start)
else Datediff(Now(), sh.date_start)
end as hobbyTime
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
where sh.DATE_FINISH IS NOT NULL
ORDER by hobbyTime desc 
Limit 10;

/*20. Вывести номера групп (без повторений), в которых учатся студенты из предыдущего запроса.*/
Select distinct s.n_group, case 
when sh.date_finish is not null then Datediff(sh.date_finish, sh.date_start)
else Datediff(Now(), sh.date_start)
end as hobbyTime
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
where sh.DATE_FINISH IS NOT NULL
ORDER by hobbyTime desc 
Limit 10;

/*21. Создать представление, которое выводит номер зачетки, имя и фамилию студентов, 
отсортированных по убыванию среднего балла.*/
Create or replace VIEW N21 
as Select S.N_Z, NAME, S.SURNAME
From STUDENTS S
ORDER by SCORE desc;

/*22. Представление: найти каждое популярное хобби на каждом курсе.*/
create or replace VIEW v3
select substr(S.N_GROUP,1,1), t1.name
from students s
inner join students_hobbies sh on s.n_z = sh.n_z
inner join (
    Select h.id as maxId, h.name as name
    From hobbies h
    inner join students_hobbies sh on sh.hobby_id = h.id
    group by h.id
    order by Count(*) desc
    limit 1
            ) t1 on sh.hobby_id = t1.maxId
group by substr(S.N_GROUP,1,1);

/*23. Представление: найти хобби с максимальным риском среди самых популярных хобби на 2 курсе.*/
create or replace VIEW v4
select substr(S.N_GROUP,1,1), t1.name
from students s
inner join students_hobbies sh on s.n_z = sh.n_z
inner join (
    Select h.id as maxId, h.name as name
    From hobbies h
    inner join students_hobbies sh on sh.hobby_id = h.id
    group by h.id
    order by Count(*) desc
    limit 1
            ) t1 on sh.hobby_id = t1.maxId, (select id as id, max(risk) from hobbies) t3
where substr(S.N_GROUP,1,1) = '2' and t1.maxId = t3.id;