/*/ Q1 SET LIBRARY AND IMPORT DATA/*/; 
LIBNAME myfolder "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework3"; 

PROC IMPORT OUT = mydata
	DATAFILE = "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework3\framinghamT3_hw3.csv"
	DBMS = CSV REPLACE;
	GETNAMES = YES;
	GUESSINGROWS =40;
	DATAROW = 2; /*/IMPORT CSV FILE /*/;
PROC CONTENTS DATA = mydata VARNUM;
RUN; /*/VIEW VARIBALES IN ORDER AND # OF OBSERVATIONS/VARIABLES/*/;

//*// Q 2//*//;

PROC FORMAT LIBRARY = myfolder;
	VALUE sex
 		0 = "Male"
		1 = "Female";
	VALUE agecat
		1 = "40-49"
 		2 = "50-59"
 		3 = "60-69"
 		4 = "70+";
	VALUE educ
 		1 = "Less than high school"
 		2 = "High school"
 		3 = "Some college"
 		4 = "College or higher";
	VALUE bmicat
 		1 = "Underweight"
 		2 = "Normal"
 		3 = "Overweight"
 		4 = "Obese";
	VALUE yesno
 		0 = "No"
 		1 = "Yes";
	VALUE cholcat
 		1 = "Optimal"
 		2 = "Borderline"
 		3 = "High-risk";
 RUN; /*/ SAVE VALUE LABELS TO LIBRARY/*/;

//*// Q3 //*//;
OPTIONS FMTSEARCH=(myfolder WORK); /*/ TELL SAS TO SEARCH FOR FORMATS IN LIBRARY/*/

DATA mydata;
	SET mydata;

	FORMAT sex sex.
 		   age agecat.
 		   educ educ.
 		   bpmeds yesno.
 		   cursmoke yesno.
 		   bmicat bmicat.
 		   diabetes yesno.
 		   totcholcat cholcat.
 		   ldlccat cholcat.;

	LABEL
 		randid     = "ID number"
 		sex        = "Sex"
 		age        = "Age (years)"
 		agecat     = "Age group"
 		educ       = "Level of completed education"
 		sysbp      = "Systolic Blood Pressure (mmHg)"
 		diabp      = "Diastolic Blood Pressure (mmHg)"
 		bpmeds     = "Use of anti-hypertensive medication"
 		heartrte   = "Heart rate (beat/min)"
 		cursmoke   = "Current cigarette smoking"
 		cigpday    = "Number of cigarettes smoked each day"
 		bmi        = "Body Mass Index (kg/m²)"
 		bmicat     = "BMI category"
 		diabetes   = "Diabetic status"
 		glucose    = "Casual serum glucose (mg/dL)"
 		totchol    = "Serum Total cholesterol (mg/dL)"
 		ldlc       = "Low-Density Lipoprotein (LDL) cholesterol (mg/dL)"
 		hdlc       = "High-Density Lipoprotein (HDL) cholesterol (mg/dL)"
 		totcholcat = "Total cholesterol status"
 		ldlccat    = "LDL Cholesterol status";
RUN; /*/APPLY LABELS AND FORMATS /*/;

//*// Q4 //*//;

PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	VAR cigpday;
	CLASS cursmoke;
RUN; /*/SUMMARY STATS OF CIGPDAY BY CURSMOKE/*/;

PROC UNIVARIATE DATA = mydata;
	VAR cigpday;
	WHERE cigpday ^= 0;
	HISTOGRAM;
RUN; /*/ DISTRIBUTION OF CIGPDAY FOR PEOPLE CURRENTLY SMOKING /*/;
/*/ IF SOMEONE IS CURRENTLY SMOKING WE EXPECT THEM To SMOKE BETWEEN 
1 AND 80 CIGARETTES PER DAY. IF SOMEONE IS NOT CURRENTLY SMOKING 
WE EXPECT THEM TO SMOKE 0 CIGARETTES PER DAY/*/;

/*/ Q5 /*/;
PROC FORMAT LIBRARY = myfolder;
	VALUE smokecat
		0 = "Non-smoker"
		1 = "Light smoker"
		2 = "Moderate smoker"
		3 = "Heavy smoker";
RUN;  /*/ SAVE FORMAT TO LIBRARY /*/;

OPTIONS FMTSEARCH=(myfolder WORK); 
/*/ TELL SAS TO SEARCH FOR FORMATS IN LIBRARY (PROBABLY NOT NEEDED AGAIN)/*/;

DATA mydata;
	SET mydata;
		IF cigpday = .						  THEN smokecat = .;
		ELSE IF cigpday =  0				  THEN smokecat = 0;
		ELSE IF cigpday >  0  & cigpday <= 10 THEN smokecat = 1;
		ELSE IF cigpday >  10 & cigpday < 20  THEN smokecat = 2;
		ELSE IF cigpday >= 20 				  THEN smokecat = 3;
FORMAT smokecat smokecat.;
RUN; /*/ CREATE SMOKECAT VARIABLE /*/;

PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	VAR cigpday;
	CLASS smokecat;
RUN; 

PROC FREQ DATA = mydata;
	TABLE smokecat;
RUN; /*/CREATE FREQ TABLE OF SMOKECAT /*/;
//*/ Q6 //*/;
PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	VAR sysbp;
	CLASS bpmeds;
RUN; 

PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	VAR diabp;
	CLASS bpmeds;
RUN; //*/ CHECK DISTRIBUTION AND FOR MISSING VALUES //*/;
PROC FORMAT LIBRARY = myfolder;
	VALUE htn
		0 = "No"
		1 = "Yes";
RUN; /*/ SAVE FORMAT TO LIBRARY /*/;

DATA mydata;
	SET mydata;
	IF bpmeds = 0  							 THEN DO;
		IF SYSBP >= 140 | DIABP >= 90        THEN htn = 1;
		ELSE  								      htn =0;
	END;
	IF bpmeds = 1   						 THEN DO;
		IF bpmeds = 1                        THEN htn = 1;
	END;
FORMAT htn htn.;
RUN; /*/ CREATE HTN VARIABLE /*/;
PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	VAR sysbp;
	CLASS htn;
RUN; 

PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	VAR diabp;
	CLASS htn;
RUN; 

PROC FREQ DATA = mydata;
	TABLE htn*bpmeds;
RUN;

PROC FREQ DATA = mydata;
	TABLE htn;
RUN; /*/ CREATE FREQ TABLE /*/

/*/ Q 7 /*/
PROC FORMAT LIBRARY = myfolder;
	VALUE hdlccat
		1 = "Optimal"
		2 = "Borderline"
		3 = "High-risk";
RUN; /*/ SAVE VALUE LABEL TO LIBRARY /*/;

DATA mydata;
	SET mydata;
	IF SEX = 0  THEN DO;
		IF hdlc = .         THEN hdlccat = .;
		ELSE IF hdlc >= 60 THEN hdlccat = 1;
		ELSE IF hdlc < 60 & hdlc >= 40 THEN hdlccat = 2;
		ELSE IF hdlc < 40  THEN hdlccat =3;
	END;
	IF SEX = 1 THEN DO;
		IF hdlc = .         THEN hdlccat = .;
		ELSE IF hdlc >= 60 THEN hdlccat = 1;
		ELSE IF hdlc < 60 & hdlc >= 50 THEN hdlccat = 2;
		ELSE IF hdlc < 50  THEN hdlccat =3;
	END;
FORMAT hdlccat hdlccat.;
RUN; /*/ CREATE HDLCCAT VARIABLE /*/;
PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	WHERE SEX = 0;
	VAR hdlc;
	CLASS hdlccat;
RUN; 

PROC MEANS DATA = mydata
	NMISS N MIN MEAN MAX STD;
	WHERE SEX = 1;
	VAR hdlc;
	CLASS hdlccat;
RUN;

PROC FREQ DATA = mydata;
	TABLE hdlccat;
RUN;  /*/ CREATE FREQ TABLE /*/;

/*/ Q 8 /*/;

PROC FREQ DATA = mydata;
	TABLE hdlccat*ldlccat*totcholcat / NOPERCENT NOCOL NOROW;
RUN;  /*/ CREATE FREQ TABLE /*/;

PROC FREQ DATA = mydata;
WHERE hdlccat = 3 | ldlccat = 3 | totcholcat = 3;
	TABLE hdlccat*ldlccat*totcholcat;
RUN;  /*/ CREATE FREQ TABLE (ADDS UP TO FREQ OF HIGH RISK CATEGOREY) /*/;

PROC FORMAT LIBRARY = myfolder;
	VALUE cholcat
		1 = "Optimal"
		2 = "Borderline"
		3 = "High-risk";
RUN;

DATA mydata;
	SET mydata;
	IF hdlccat = . | ldlccat = . | totcholcat = . 				THEN cholcat = .;
	ELSE IF hdlccat = 1 and ldlccat = 1 and totcholcat = 1 				THEN cholcat = 1;
	ELSE IF hdlccat = 3 | ldlccat = 3 | totcholcat = 3 				THEN cholcat = 3;
	ELSE 			                                             cholcat = 2;
FORMAT cholcat cholcat.;
RUN;

PROC FREQ DATA = mydata;
	TABLE cholcat;
RUN;  /*/ CREATE FREQ TABLE /*/;

PROC FREQ DATA = mydata;
	TABLE hdlccat*ldlccat*totcholcat*cholcat / NOPERCENT NOCOL NOROW;
RUN;  /*/ CREATE FREQ TABLE /*/;

PROC CONTENTS DATA = mydata VARNUM;
RUN;
/*/ Q 9 /*/;
DATA myfolder.framinghamT3_hw3_clean;
	SET mydata;
	LABEL
 		smokecat   = "Smoking categorey"
 		htn        = "Hypertension status"
 		hdlccat    = "HDL cholesterol status"
 		cholcat    = "Cholesterol categorey";
RUN; /*/APPLY LABELS AND FORMATS /*/;
PROC CONTENTS DATA = myfolder.framinghamT3_hw3_clean VARNUM;
RUN; /*/ CHECK IF LABELS ARE ATTACHED /*/;
/*/ Q 10 /*/;
LIBNAME myfolder "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework3";

OPTIONS FMTSEARCH=(myfolder WORK);
DATA dataclean;
	SET myfolder.framinghamT3_hw3_clean;
RUN;
PROC CONTENTS DATA = dataclean VARNUM;
RUN;
