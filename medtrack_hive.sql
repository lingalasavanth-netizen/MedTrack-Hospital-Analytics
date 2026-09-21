ADD JAR /root/medtrack/LengthOfStayUDF.jar;
CREATE TEMPORARY FUNCTION lengthOfStay AS 'com.medtrack.hive.LengthOfStayUDF';

USE medtrack_db;

-- Aligned and formatted output matching Problem 2 specification
SELECT 
    rpad(d.dept_name, 25, ' ') AS department,
    printf(': %.2f days', AVG(lengthOfStay(a.admit_date, a.discharge_date))) AS avg_stay
FROM admissions a
JOIN departments_rcfile d ON a.dept_code = d.dept_code
WHERE a.admission_id != 'admissionId'
GROUP BY d.dept_name
ORDER BY d.dept_name;
