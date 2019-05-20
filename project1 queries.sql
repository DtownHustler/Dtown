--1. Заполнить таблицы данными, необходимыми для наглядного выполнения запросов
insert into region_doctors (name, surname) VALUES ("Доктор", "Ватсон");
insert into region_doctors (name, surname) VALUES ("Лена", "Головач");
insert into region_doctors (name, surname) VALUES ("Зураб", "Подмыхин");

insert into patients (name, surname) VALUES ("Бабулька", "Старенькая");
insert into patients (name, surname) VALUES ("Дед", "Пердед");
insert into patients (name, surname) VALUES ("Джонии", "Ноксвелл");

insert into region (doctors_id, patients_id, name) VALUES (1, 1, "Сараево");
insert into region (doctors_id, patients_id, name) VALUES (2, 2, "Купянск");
insert into region (doctors_id, patients_id, name) VALUES (2, 3, "Купянск");

insert into specialists (name, surname) VALUES ("Виталий", "Шоколадный-Глаз");
insert into specialists (name, surname) VALUES ("Зинаида", "Гнойная");
insert into specialists (name, surname) VALUES ("Михаил", "Чикатило");

insert into specialists_patients (specialists_id, patients_id, visited) VALUES (2, 2, "Не явился(-ась)");
insert into specialists_patients (specialists_id, patients_id, visited) VALUES (2, 3, "Явился(-ась)");
insert into specialists_patients (patients_id, specialists_id, visited) VALUES (1, 1, "Не явился(-ась)");

insert into doctors_tickets_patients (date_expired, date_received, patients_id, region_doctors_id) VALUES ("2030-11-13", Now(), 1, 1);

insert into doctors_patients (doctors_id, patients_id, visited) VALUES (2, 2, "Явился(-ась)");

--2. Написать запрос на каждую таблицу, который добавляет в неё данные (исключая атрибут, который заполняется при помощи автоинкремента)
insert into region_doctors (name, surname) VALUES (rd_name, rd_surname);

--3. Написать запрос на каждую таблицу, который возвращает запись с заданными ID
select rd.*
from region_doctors rd
where rd.id = rd_id;

select dp.*
from doctors_patients dp
where dp.id = dp_id;

select dtp.*
from doctors_tickets_patients dtp
where dtp.id = dtp_id;

select rd.*
from region_doctors rd
where rd.id = rd_id;

select p.*
from patients p
where p.id = p_id;

select s.*
from specialists s
where s.id = s_id;

select r.*
from region r
where r.id = r_id;

select sp.*
from specialist_patients sp
where sp.id = sp_id;

--4. Написать запрос на каждую таблицу, который изменяет данные для заданного ID
update region_doctors
set name = rd_name
where id = rd_id;

update doctors_patients
set visited = dp_visited
where id = dp_id;

update doctors_tickets_patients
set date_expired = dtp_date_expired
where id = dtp_id;

update patients
set name = p_name
where id = p_id;

update region
set doctors_id = region_doctors_id
where id = r_id;

update specialists
set surname = s_surname
where id = s_id;

update specialists_patients
set visited = sp_visited
where id = s_id;

--5. Написать запрос на каждую таблицу, который удаляет запись в таблице с заданным ID
delete 
from region_doctors
where id = rd_id;

delete 
from doctors_patients
where id =dp_id;

delete 
from doctors_tickets_patients
where id = dtp_id;

delete 
from patients
where id = p_id;

delete 
from region
where id = r_id;

delete 
from specialists
where id = s_id;

delete 
from specialist_patients
where id = sp_id;

--6. Для каждого специалиста выведите количество активных направлений к нему
-- как понять, что направление активное?
select s.name, Count(*)
from specialists s
inner join specialists_patients sp on sp.specialists_id = s.id
group by sp.specialists_id;

--7. Для заданного врача выведите список свободных приемов в заданный день

-- ?

--8. Для каждого участкового вывести 2-х самых часто посещающих его пациента
-- оно не запустилось
select dp.*, Count(*) as counter
from doctors_patients dp
group by dp.doctors_id, dp.patients_id
having dp.visited = "Явился(-ась)"
order by counter desc
limit 2;

--9. Выведите пациентов, которые не явились на приём более 3-х раз
-- тоже не запускается, 8 и 9 смотри на group by. Там должны быть все атрибуты, которые выводятся в Select (не считая групповых функций)
select dp.*
from doctors_patients dp
group by dp.patients_id
having Count(*) > 3 and dp.visited = "Не явился(-ась)";

--10. Для каждого участка выведите отношение количества участовых к количеству пациентов на участке
-- как и 8,9 
select r.name, 1/Count(*)
from region r
group by r.doctors_id;

--11.1 Выведите id всех пациентов для каждого специалиста
select s.name, s.surname, p.name, p.surname
from specialists s
inner join specialists_patients sp on sp.specialists_id = s.id
inner join patients p on p.id = sp.patients_id;

--11.2. Для каждого участка вывести закрепленных на нем пациентов
select r.name, p.name, p.surname
from region r, patients p
where r.patients_id = p.id;

--11.3 Выведите информацию о пациентах, чей талон на прием просрочен
select p.name, p.surname
from patients p, doctors_tickets_patients dtp
where p.id = dtp.patients_id and date_expired < Now();

--11.4 Вывести всю информацию о пациентах и количество раз, которые они были у участкового врача
select p.name, p.surname, Count(*)
from patients p, doctors_patients dp
where p.id = dp.patients_id and dp.visited = "Явился(-ась)"
group by dp.patients_id;

--11.5 Вывести информацию об участковых врачах и название их участка
select rd.name, rd.surname, r.name
from region_doctors rd, region r
where rd.id = r.doctors_id;

--12.1 Обновление информации об отсутствии пациента на приеме у специалиста
update specialist_patients sp
set sp.visited = v_value;
where sp.specialists_id = sp_id and sp.patients_id = p_id;

--12.2 Продление талона на прием к специалисту
update doctors_tickets_patients dtp
set dtp.date_expired = de_value
where dtp.doctors_id = rd_id and dtp.patients_id = p_id;

--12.3 Изменение имени у определенного участкового врача
update region_doctors rd
set rd.name = rd_name
where rd.id = rd_id;

--13.1 Удалить все просроченные талоны
delete
from dtp_date_expired dtp
where dtp.date_expired < Now();

--13.2 Удалить записи обо всех неявившихся пациентов у участковых врачей
delete 
from doctors_patients dp 
where dp.visited = "Не явился(-ась)";

--13.3 Удалить записи обо всех неявившихся пациентов у специалистов
delete 
from specialist_patients sp 
where sp.visited = "Не явился(-ась)";
