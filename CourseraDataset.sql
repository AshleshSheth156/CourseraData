use CourseraDataset;

select * from Data;

desc data;

-- Top 5 organization has the most number of courses?

select course_organization, count(ID) as TotalNumberOfCourses 
from Data
group by course_organization
order by TotalNumberOfCourses Desc
Limit 5;

-- Average course rating of the organizations with more than 10 courses

SELECT course_organization, count(ID) AS TotalNumberOfCourses, Round(avg(course_Rating), 2) as AverageRating
FROM Data
GROUP BY course_organization
HAVING TotalNumberOfCourses > 10
ORDER BY TotalNumberOfCourses Desc;

-- Find the top-rated course from each organization
SELECT d1.course_organization, d1.course_title, d1.course_rating 
FROM data as d1
JOIN 
(
	SELECT course_organization, MAX(course_rating) as maxRate
    FROM data 
    GROUP BY course_organization
) d2
ON d1.course_organization =  d2.course_organization AND d1.course_rating = d2.maxRate;


-- Calculate the average rating for each combination of difficulty and certificate type
SELECT course_difficulty, course_certificate_type, ROUND(avg(course_rating),2) as averageRating
FROM data  
GROUP BY course_difficulty, course_certificate_type
ORDER BY averageRating DESC;



-- Find courses with a rating higher than the average rating for their organization:

SELECT d1.course_title,d1.course_organization, d1.course_rating
FROM data AS d1
JOIN(
	SELECT AVG(course_rating) AS averageRating, course_organization
    FROM data
    GROUP BY course_organization
) AS d2 
ON d1.course_organization = d2.course_organization
WHERE d1.course_rating > d2.averageRating;


-- List the organizations that offer courses with a difficulty level of 'Intermediate' or 'Advanced' and have more than 100,000 students enrolled:

-- As the Column, course_students_enrolled have values like 9.8k, 150k,2m, etc, we have to change it to integer. 
BEGIN;
UPDATE data
SET course_students_enrolled = 
  CASE 
    WHEN course_students_enrolled LIKE '%k' THEN
      REPLACE(course_students_enrolled, 'k', '') * 1000
    WHEN course_students_enrolled LIKE '%m' THEN
      REPLACE(course_students_enrolled, 'm', '') * 1000000
    ELSE course_students_enrolled
  END;
ROllBACK;
COMMIT;

SELECT course_organization,course_difficulty, course_students_enrolled
FROM data
WHERE course_difficulty = 'Intermediate' OR course_difficulty = 'Advanced' AND course_students_enrolled > 100000;

-- Calculate the total number of students enrolled in each difficulty level
SELECT course_difficulty, sum(course_students_enrolled) AS total_number_of_students_enrolled
FROM data
GROUP BY course_difficulty; 

-- Find the course with the highest number of students enrolled and its organization:
SELECT course_title, course_organization, course_students_enrolled
FROM data
ORDER BY course_students_enrolled DESC
LIMIT 1;

-- Find the course with the highest number of students enrolled and for each organization
SELECT course_organization, course_title, MAX(course_students_enrolled) AS max_students_enrolled
FROM data
GROUP BY course_organization, course_title
ORDER BY max_students_enrolled DESC;


