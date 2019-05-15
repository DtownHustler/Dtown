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

insert into doctors_tickets_patients (date_expired, date_received, patients_id, region_doctors_id) VALUES ("2030-11-13", Now(), 1, 1);

insert into specialists_patients (patients_id, specialists_id, visited) VALUES (1, 1, "Не явился(-ась)");

insert into doctors_patients (doctors_id, patients_id, visited) VALUES (2, 2, "Явился(-ась)");

--2. Написать запрос на каждую таблицу, который добавляет в неё данные (исключая атрибут, который заполняется при помощи автоинкремента)
insert into region_doctors (name, surname) VALUES (rd_name, rd_surname);

--3. Написать запрос на каждую таблицу, который возвращает запись с заданными ID
select rd.*
from region_doctors rd
where rd.id = rd_id;

--4. Написать запрос на каждую таблицу, который изменяет данные для заданного ID
update region_doctors
set name = rd_name
where id = rd_id;

--5. Написать запрос на каждую таблицу, который удаляет запись в таблице с заданным ID
delete 
from region_doctors
where id = rd_id;

--6. Для каждого специалиста выведите количество активных направлений к нему
select s.name, Count(*)
from specialists s
inner join specialists_patients sp on sp.specialists_id = s.id
group by sp.specialists_id;

--7. Для заданного врача выведите список свободных приемов в заданный день

--8. Для каждого участкового вывести 2-х самых часто посещающих его пациента
select dp.*, Count(*) as counter
from doctors_patients dp
group by dp.doctors_id, dp.patients_id
having dp.visited = "Явился(-ась)"
order by counter desc
limit 2;

--9. Выведите пациентов, которые не явились на приём более 3-х раз
select dp.*
from doctors_patients dp
group by dp.patients_id
having Count(*) > 3 and dp.visited = "Не явился(-ась)";

--10. Для каждого участка выведите отношение количества участовых к количеству пациентов на участке
select r.name, 1/Count(*)
from region r
group by r.doctors_id;