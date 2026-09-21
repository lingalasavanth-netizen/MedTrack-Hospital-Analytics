raw_admissions = LOAD '/root/medtrack/admissions.csv' USING PigStorage(',') 
    AS (admissionId:chararray, patientName:chararray, deptCode:chararray, admitDate:chararray, dischargeDate:chararray);

raw_departments = LOAD '/root/medtrack/departments.csv' USING PigStorage(',') 
    AS (deptCode:chararray, deptName:chararray, headOfDept:chararray);

clean_admissions = FILTER raw_admissions BY admissionId != 'admissionId';
clean_departments = FILTER raw_departments BY deptCode != 'deptCode';

patient_stays = FOREACH clean_admissions GENERATE 
    deptCode,
    DaysBetween(ToDate(dischargeDate, 'yyyy-MM-dd'), ToDate(admitDate, 'yyyy-MM-dd')) AS stayDays;

joined_stays = JOIN patient_stays BY deptCode, clean_departments BY deptCode;

grouped_dept = GROUP joined_stays BY clean_departments::deptName;

avg_stay_result = FOREACH grouped_dept GENERATE 
    group AS deptName, 
    ROUND_TO(AVG(joined_stays.patient_stays::stayDays), 2) AS avgStay;

sorted_result = ORDER avg_stay_result BY deptName ASC;

DUMP sorted_result;
