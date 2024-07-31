use student;
--A system to store Student mark list for maths and english for the entire academic year. 
--Student Id, Name ,Tel.No, gender etc, to be captured. Term wise and Test wise results  of each subject to be stored. 

CREATE TABLE Students (
    StudentID INT IDENTITY(1,1),
	Rollno int primary key,
    Name NVARCHAR(100),
    Gender CHAR(1),
    TelNo NVARCHAR(15),
	phoneno NVARCHAR(12),
);
drop table Students;
drop table Marks;
CREATE TABLE Marks (
    MarkID INT PRIMARY KEY IDENTITY(1,1),
    Rollno INT FOREIGN KEY REFERENCES Students(Rollno),
    Term INT,
    Test VARCHAR(50),
    englishMark INT,
	mathsmarks INT,
	totalmarks int
);
INSERT INTO Students values (1,'preethi','f','2724162',''),(2,'anu','f','2724962','9778257855'),
(3,'manu','m','2924162',''),(4,'jopu','m','2724002',''),
(5,'mahi','m','2728962','9778457878'),(6,'sam','m','2789919','922781988'),(7,'Rahul','m','235678',''),
(8,'Raju','m','235678','6789292'),(9,'anup','m','282828','');
exec sp_help Students;
exec sp_help Marks;

insert into Marks values (1,1,'semester',80,90,200),(2,1,'semester',70,90,170),
(3,2,'semester',80,70,290),(4,2,'revision',90,70,200),(5,2,'semester',86,79,189),
(6,1,'semester',80,67,279),(7,2,'semester',86,70,260),(8,1,'semester',86,67,180),
(9,2,'semester',96,82,200);

select* from Students;
select* from Marks;

--1. Student name and maths mark for term 1 for all students
SELECT Students.Name, Marks.mathsmarks AS MathsMark
FROM Students 
JOIN Marks  ON Students.Rollno = Marks.Rollno
WHERE Marks.Term = 1;

--2. Student id and total marks of the student
SELECT Students.StudentID, SUM(totalmarks) AS TotalMarks
FROM Students 
JOIN Marks ON Students.Rollno = Marks.Rollno
GROUP BY Students.StudentID;

--3. Student details for all students whose name starts with S or has P in their name. Sort in ascending order of name
SELECT *
FROM Students
WHERE Name LIKE 'S%' OR Name LIKE '%P%'
ORDER BY Name ASC;

--4. Student name and English mark for term 2 for all students. If mark is not there, show 'A' in the place of mark
SELECT Students.Name, COALESCE(CAST(Marks.englishMark AS VARCHAR(10)), 'A') AS EnglishMark
FROM Students 
 Left JOIN Marks ON Students.Rollno = Marks.Rollno AND Marks.Term = 2;

--5. Student id and total marks of the student for all boys
SELECT Students.StudentID, SUM(totalmarks) AS TotalMarks
FROM Students 
JOIN Marks ON Students.Rollno = Marks.Rollno
WHERE Students.Gender = 'M'
GROUP BY Students.StudentID;

--6. Student details for all students whose has phone number and whose name starts with A. Sort in ascending order of name
SELECT *
FROM Students
WHERE Phoneno IS NOT NULL AND Phoneno != '' 
AND Name LIKE 'A%'
ORDER BY Name ASC;

--7. Student name and English mark for term 2 for all students. If mark is not there, show '0' in the place of mark
SELECT Students.Name, 
       COALESCE(CAST(Marks.englishMark AS VARCHAR(10)), '0') AS EnglishMark
FROM Students LEFT JOIN Marks
ON Students.Rollno =Marks.Rollno  AND Marks.Term = 2;

--8. Student details for all boys who has the same mark for maths as 'Rahul'
SELECT * FROM Students 
JOIN Marks ON Students.Rollno = Marks.Rollno
WHERE Students.Gender = 'm' AND Marks.mathsmarks = 
    (SELECT mathsmarks FROM Marks WHERE Rollno = 
        (SELECT Rollno FROM Students WHERE Name = 'Rahul')
    ) order by mathsmarks;

