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

/*Многотабличные*/