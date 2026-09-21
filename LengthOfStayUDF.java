package com.medtrack.hive;

import org.apache.hadoop.hive.ql.exec.UDF;
import java.text.SimpleDateFormat;
import java.util.Date;

public class LengthOfStayUDF extends UDF {
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public Double evaluate(String admitDate, String dischargeDate) {
        if (admitDate == null || dischargeDate == null) return null;
        try {
            Date d1 = sdf.parse(admitDate.trim());
            Date d2 = sdf.parse(dischargeDate.trim());
            long diffMs = d2.getTime() - d1.getTime();
            return (double) (diffMs / (1000 * 60 * 60 * 24));
        } catch (Exception e) {
            return null;
        }
    }
}
