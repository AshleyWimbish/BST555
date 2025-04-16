/*/CREATE LIBRARY IN HOMEWORK 2 FOLDER/*/;
LIBNAME myfolder "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework2";

/*/ SAVE ORIGINAL DATA AS TEMP FILE CALLED ORIGINAL /*/;
DATA original;
	SET myfolder.framingham_hw2;
RUN;
/*/VIEW NUMBER OF OBSERVATIONS AND VARIABLES IN ORDER/*/;
PROC CONTENTS DATA = original VARNUM;
RUN;
/*/ LABEL VALUES FOR CATEGORICAL VARIABLES /*/;
PROC FORMAT;
	VALUE sex
 		0 = "Male"
 		1 = "Female";
	VALUE educ
		1 = "Less than high school"
		2 = "High school"
		3 = "Some college"
		4 = "College or higher";
	VALUE yesno
		0 = "No"
		1 = "Yes";
RUN; 
/*/ ATTACH LABELS /*/;
DATA original;
	SET original;
	FORMAT 
		Sex sex.
		Educ educ.
		Htn yesno.
		Cursmoke yesno.
		Diabetes yesno.;
RUN;
/*/ CHECK THE FORMATS ARE ATTACHED /*/;
PROC CONTENTS DATA = original VARNUM;
RUN;
/*/ CREATE AGECAT VARIABLE /*/;
PROC FORMAT;
	VALUE AGEcat
		1 = "30-39"
		2 = "40-49"
		3 = "50-59"
		4 = "60+  ";
RUN;
/*/ ATTACH AND DEFINE VALUE LABELS /*/;
DATA original;
	SET original;
	IF       Age = .                 THEN AGEcat = .;
	ELSE IF  Age =<  39              THEN AGEcat = 1;
	ELSE IF  Age >= 40 and Age =< 49 THEN AGEcat = 2;
	ELSE IF  Age >= 50 and Age =< 59 THEN AGEcat = 3;
	ELSE IF  AGE >= 60               THEN AGEcat = 4;
	FORMAT AGEcat AGEcat.;
RUN;
/*/ CHECK MIN AND MAX VALUES OF NEW VARIABLE/*/;
PROC MEANS DATA = original 
 MIN MAX;
 VAR AGE;
 CLASS AGEcat;
RUN;
/*/ CREATE BMI CATEGORY /*/;
PROC FORMAT;
VALUE BMIcat
	1 = "Underweight"
	2 = "Normal"
	3 = "Overweight"
	4 = "Obese";
RUN;
/*/ ATTACH AND DEFINE VALUE LABELS /*/;
DATA original;
	SET original;
	IF BMI = .         THEN BMIcat = .;
	ELSE IF BMI < 18.5 THEN BMIcat = 1;
	ELSE IF BMI < 25.0 THEN BMIcat = 2;
	ELSE IF BMI < 30.0 THEN BMIcat = 3;
	ELSE IF BMI > 30.0 THEN BMIcat = 4;
	FORMAT BMIcat bmicat.;
RUN;
/*/ CHECK MIN AND MAX VALUES OF NEW VARIABLE/*/;
PROC MEANS DATA = original 
 MIN MAX;
 VAR BMI;
 CLASS BMIcat;
RUN;
/*/ FIND MISSING VALUES FOR VARIABLES OF INTEREST /*/;
PROC MEANS DATA = original
	NMISS;
	VAR AGE SYSBP DIABP BMI;
RUN;
/*/ CREATE NEW SUBSET DATA SET WITHOUT MISSING VALUES /*/;
DATA subset;
	SET original;
	WHERE AGE   ^= . and
		  SYSBP ^= . and 
		  BMI   ^= . and
		  DIABP ^= .;
RUN;
/*/ VERIFY NO MISSING VALUES /*/;
PROC MEANS DATA = subset
	NMISS;
	VAR AGE SYSBP DIABP BMI;
RUN;
/*/ summary statistics of continuous variables /*/;
PROC MEANS DATA = subset 
 MEAN STD MAXDEC = 1;
 VAR SYSBP DIABP;
 CLASS Sex;
RUN;
/*/  frequency tables for each categorical variable /*/;
PROC FREQ DATA = subset;
	TABLE AGEcat*Sex / NOPERCENT NOROW;
	TABLE BMIcat*Sex / NOPERCENT NOROW;
	TABLE Htn*Sex / NOPERCENT NOROW;
	TABLE CURSMOKE*Sex / NOPERCENT NOROW;
	TABLE Educ*Sex / NOPERCENT NOROW;
RUN;
/*/ SAVE DATA SET IN A PERMANENT FOLDER  /*/;
DATA myfolder.framingham_hw2_clean;
	SET subset;
	FORMAT 
		Sex 
		Educ
		Htn 
		Cursmoke 
		Diabetes;
RUN;
/*/CHECK THAT VALUES ARE REMOVED/*/;
PROC CONTENTS DATA = myfolder.framingham_hw2_clean VARNUM;
RUN;
