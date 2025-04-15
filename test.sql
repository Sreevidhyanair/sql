--DDL&DML 
--Q1

CREATE TABLE Patient(
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
	gender varchar(10),
    date_of_birth DATE,
    contact_number VARCHAR(15)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_name VARCHAR(100),
    appointment_date DATE,
    department VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);
--Q2
alter table Appointment add column status varchar(20);
--Q3
insert into patient values(1,'John Doe','Male','1980-12-31','9876543210'),
(2,'Anushka Sharma','Female','1982-10-01','8876543210'),
(3,'Tom Hiddleston','Male','1990-10-10','9966543210'),
(4,'Zawe Ashton','Female','1988-02-03','9876543210'),
(5,'Mitchell Mark','Male','1976-12-31','8876533210');


insert into Appointment values
(1, 1, 'Dr.Smith', '2025-04-10', 'Cardiology', 'Completed'),
(2, 2, 'Dr.Johnson', '2025-04-15', 'Orthopedics', 'Scheduled'),
(3, 3, 'Dr.Smith', '2025-04-20', 'Cardiology', 'Scheduled'),
(4, 4, 'Dr.Wilson', '2025-04-12', 'Dermatology', 'Completed'),
(5, 5, 'Dr.Brown', '2025-04-18', 'Cardiology', 'Scheduled');
--Q4
update Appointment set department='Neurology'where appointment_id=2;
--Q5
delete from patient where name='John Doe';

--SELECT&JOIN 
--Q6
select p.name,a.appointment_date,a.doctor_name 
from Patient p left join Appointment a on 
p.patient_id=a.patient_id;
--Q7
select p.name from Patient p join Appointment a
on p.patient_id=a.patient_id where a.department='Cardiology';
--Q8
select p.name from Patient p join Appointment a
on p.patient_id=a.patient_id where a.doctor_name='Dr.Smith';
--Q9
select a.*,p.name from Appointment a join Patient p
on p.patient_id=a.patient_id where
(current_date-p.date_of_birth)/365>60;

--Q10
select p.name,count(*) as appt_count from 
Patient p join Appointment a on p.patient_id=a.patient_id 
group by p.patient_id having count(*)>1;

--SUBQUERY&FUNCTIONS
--Q11
select name from Patient where patient_id=
(select patient_id from Appointment a 
group by patient_id order by count(*) desc limit 1 );
--Q12
select name from Patient where patient_id not in
(select patient_id from Appointment);
--Q13
select name,(current_date-date_of_birth)/365 as age from Patient;
--Q14
select a.* from Appointment a where appointment_date
between '2025-01-15' and '2025-04-15';
--Q15
select a.department,count(*) as appt_count from Appointment a
group by a.department;

--SQL QUESTIONS
--Q1
select p.name from Patient p where not exists(
select distinct department from Appointment where
department not in (select department from Appointment
where patient_id = p.patient_id));
--Q2
select p.name as patient_name,a.doctor_name,count(*)
as appointment_count from Patient p JOIN Appointment a 
on p.patient_id = a.patient_id where a.doctor_name='Dr.Smith'
group by p.name,a.doctor_name having count(*)=1;
--Q3
select a.doctor_name,count(DISTINCT a.patient_id) 
as patient_count,string_AGG(DISTINCT p.name, ', ') as patient_names
from Appointment a join Patient p on a.patient_id = p.patient_id
group by a.doctor_name having count(distinct department)>1 and
count(distinct a.patient_id) > 2;
--Q4
SELECT * FROM Appointment WHERE 
appointment_date >= CURRENT_DATE - INTERVAL '7 days';
--Q5
select name from Patient where patient_id in
(select patient_id from Appointment a 
group by patient_id order by count(*) desc limit 3 );

