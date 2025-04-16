/*/ Setting Library Name/ file path /*/

LIBNAME myfolder "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing/Homework1";

/*/ VIEW VARIABLES IN ORDER /*/
PROC CONTENTS DATA = myfolder.heart_subset VARNUM;
RUN;
/*/ GET SUMMARY STATS FOR HEIGHT/WEIGHT /*/
PROC MEANS DATA = myfolder.heart_subset
	NMISS N MIN MAX MEAN;
	VAR Height Weight;
RUN;
/*/ CREATE VARIABLES HEIGHT/WEIGHT IN METRIC SYSTEM /*/	
DATA mydata;
	SET myfolder.heart_subset;
	Height_cm = Height * 2.54;
	Weight_kg = Weight * 0.453592;
RUN;
/*/ GET SUMMARY STATS FOR HEIGHT/WEIGHT IN METRIC SYSTEM /*/
PROC MEANS DATA = mydata
	NMISS N MIN MAX MEAN;
	VAR Height_cm Weight_kg;
RUN;
/*/ CREATE BMI VARIABLE /*/
DATA mydata;
	SET mydata;
	BMI = Weight_kg/((Height_cm/100)**2);
RUN;
/*/ GET SUMMARY STATS FOR BMI /*/
PROC MEANS DATA = mydata
	NMISS N MIN MAX MEAN;
	VAR BMI;
RUN;
/*/ GET SUMMARY STATS FOR CHOLESTEROL /*/
PROC MEANS DATA = mydata
	NMISS N MIN MAX MEAN;
	VAR Cholesterol;
	CLASS Chol_Status;
RUN;
/*/ FORMAT SEX VARIABLE /*/
PROC FORMAT;
	VALUE sex
	1 = "Male"
	2 = "Female";
RUN;
/*/ APPLY FORMAT FOR SEX VARIABLE /*/
DATA mydata;
	SET mydata;
	FORMAT Sex sex.;
RUN;
/*/ CREATE TABLE FOR SEX VARIABLE /*/
PROC FREQ DATA = mydata;
	TABLE Sex;
RUN;
/*/SET VARIABLE LABELS /*/
DATA mydata;
	SET mydata;
	LABEL Height_cm = "Height(cm)"
	Height = "Height"
	Weight_kg = "Weight(kg)"
	Weight = "Weight(in)"
	BMI = "Body Mass Index (kg/m^2)";
RUN;
/*/CHECK VARIABLE LABELS/*/
PROC CONTENTS DATA = mydata VARNUM;
RUN;
/*/ SAVE CLEAN LABELLED DATA/*/ 
DATA myfolder.clean_heart_WimbishA;
	SET mydata;
RUN;

