LIBNAME myfolder "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework4";

/*/ Q 1 /*/;
PROC IMPORT DATAFILE = "C:\Users\aw3587\OneDrive - Drexel University\Fall_24
\Intro_to_Stats_Computing\Homework4\state-geocodes-v2021.xlsx"
	OUT = AdminCode
	DBMS = XLSX REPLACE;
	GETNAMES = NO;
	DATAROW = 7;
RUN;  /*/ Import the data /*/;

ODS SELECT Position;
PROC CONTENTS VARNUM; 
RUN;
ODS SELECT DEFAULT;
PROC PRINT; 
RUN; /*/ CHECK VARIABLE TYPE (ALL CHAR) /*/;

DATA AdminCode;
SET AdminCode
 (RENAME = (A=Region B=Division C=State D=Name));
LABEL Region =
 Division =
 State =
 Name = ;
RUN; 

ODS SELECT Position;
PROC CONTENTS VARNUM; RUN;
ODS SELECT DEFAULT;

PROC PRINT DATA = Admincode;
RUN;

/*/ Q 2 /*/;
/*////////// REGION ////////////*/;
DATA Region;
	SET AdminCode (DROP = Division State);
	IF FIRST.Region = 1 THEN OUTPUT;
	BY Region;
	RENAME Name = RegionName;
RUN; /*/ SELECT REGION OBSERVATIONS /*/;

PROC PRINT DATA = Region;
RUN; /*/ PRINT REGION DATA /*/;

/*////////// DIVISION ////////////*/;

PROC SORT DATA = AdminCode OUT = AdminCode; 
	BY Division; 
RUN; /*/ SORT BY DIVISION /*/;

DATA Division;
	SET AdminCode (DROP = State);
	IF FIRST.Division = 1 THEN OUTPUT;
	BY Division;
	RENAME Name = DivisionName;
RUN; /*/ SELECT DIVISION OBSERVATIONS /*/;

DATA Division;
	SET Division;
	IF Division = 0 THEN DELETE;
RUN; /*/ REMOVE REGION OBSERVATION /*/;

PROC PRINT DATA = Division;
RUN; /*/ PRINT DIVISION TABLE /*/;


/*////////// STATE ////////////*/;

DATA State;
	SET AdminCode;
	IF State ^= 00 THEN OUTPUT;
	RENAME Name = StateName;
RUN; /*/ SELECT STATE OBSERVATIONS /*/;

PROC PRINT DATA = State;
RUN; /*/ PRINT STATE TABLE /*/;

/*/ Q 3 /*/;

DATA AdminNew;
	MERGE Region Division State;
	BY Region; /*/ MERGE DATA BY REGION /*/
RUN;

PROC PRINT DATA = AdminNew;
RUN;

/*/ Q 4 /*/;
PROC IMPORT OUT = est2023_csv
	DATAFILE = "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework4\est2023.csv"
	DBMS = CSV REPLACE;
	GUESSINGROWS = MAX;
	GETNAMES = YES;
	DATAROW = 2;

PROC CONTENTS DATA = est2023_csv VARNUM;
RUN; /*/ 3195 OBSERVATIONS /*/

DATA Main2023;
	SET est2023_csv;
	IF county ^= 000 THEN OUTPUT;
RUN;

PROC CONTENTS DATA = Main2023 VARNUM;
RUN; /*/ 3144 OBSERVATIONS W/O STATE TOTALS /*/;

/*/ Q 5 /*/;

DATA Main2023 (DROP = Region Division);
	SET Main2023;
RUN;

PROC SORT DATA = AdminNew OUT = AdminNew;
	BY State;
RUN; /*/ SORT BY STATE /*/;

DATA Data2023;
	MERGE AdminNew Main2023;
	BY State; /*/ MERGE DATA BY State /*/;
RUN;

PROC CONTENTS DATA = Data2023 VARNUM;
RUN;

DATA Data2023_Matched;
    MERGE AdminNew (IN = InAdminNew)
            Main2023 (IN = InMain2023);
    BY State;
    IF InAdminNew AND InMain2023; /*/ SHOW ONLY MATCHED DATA /*/;
RUN;

PROC CONTENTS DATA = Data2023_Matched VARNUM;
RUN; /*/ NUMBER OF OBSERVATIONS ARE EQUAL SO NO UNMATCHED OBSERVATIONS /*/;

/*/ Q 6 /*/

DATA BirthSum (RENAME = (births = StateBirths));
	SET est2023_csv (KEEP = state stname births);
	IF FIRST.state = 1 THEN OUTPUT;
	BY State;
RUN;  /*/ CREATE STATE TOTAL DATA /*/;

PROC PRINT DATA = BirthSum;
RUN;

/*/ Q 7 /*/;

DATA Data2023 (DROP = Stname);
	MERGE Data2023 BirthSum;
	BY State; /*/ MERGE DATA BY State /*/
RUN;

PROC PRINT DATA = DATA2023;
	WHERE StateBirths = 10725;
RUN; /*/SEE SUBSET OF DATA /*/;

/*/ Q 8 /*/;
/*/ DATA Data2023;
		RETAIN State County StateName CtyName Births StateBirths;
		SET Data2023 (KEEP = State County StateName CtyName Births StateBirths);
		BirthPct = (Births/StateBirths) * 100;
RUN;  /*/; /*/TO GET EXACT TABLE /*/;

 DATA Data2023;
		RETAIN State County StateName CtyName Births StateBirths;
		SET Data2023;
		BirthPct = (Births/StateBirths) * 100;
RUN; /*/ CREATE  VARIABLE /*/;

PROC PRINT DATA = Data2023;
	WHERE StateBirths = 10725;
RUN;

/*/ Q 9 /*/;

/*/ SORT IN DESCENDING ORDER /*/;
PROC SORT DATA = Data2023 OUT = Data2023;
	BY State descending RBirth ;
RUN;

DATA Data2023;
	SET Data2023 (KEEP = State StateName CtyName RBirth);
	BY State descending RBirth;
	RETAIN RankHtoL;
	IF FIRST.State = 1 THEN RankHtoL = 1;
	ELSE                 RankHtoL = RankHtoL + 1; /*/ CREATE RANKHTOL VARIABLE /*/;
RUN;

PROC PRINT DATA = Data2023;
	WHERE StateName = "Delaware";
RUN;

/*/ Q 10 /*/;

PROC IMPORT OUT = est2021_csv
	DATAFILE = "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework4\est2021.csv"
	DBMS = CSV REPLACE;
	GUESSINGROWS = MAX;
	GETNAMES = YES;
	DATAROW = 2;

PROC CONTENTS DATA = est2021_csv VARNUM;
RUN; /*/ 3195 OBSERVATIONS /*/

DATA Main2021;
	SET est2021_csv;
	IF county ^= 000 THEN OUTPUT;
RUN;

PROC CONTENTS DATA = Main2021 VARNUM;
RUN; /*/ 3144 OBSERVATIONS W/O STATE TOTALS /*/;

DATA Main2023;
	SET est2023_csv;
	IF county ^= 000 THEN OUTPUT;
RUN;

DATA MainLong;
	SET Main2021 Main2023;
RUN; /*/ 6288 observations /*/;

PROC PRINT DATA = MainLong;
	WHERE stname = "Delaware";
RUN; /*/ VIEW PART OF DATA /*/;

/*/ Q 11 /*/;
PROC SORT DATA = MainLong OUT = MainLong;
	BY Region Division State County;
RUN;

PROC TRANSPOSE DATA = MainLong
	OUT = MainWide;
	BY  Region Division State StName County CtyName;
	ID Year;
	VAR RBirth; /*/ TRANSPOSE MAIN LONG /*/;
RUN;

PROC PRINT DATA = MainWide;
	WHERE StNAme = "Delaware";
RUN; /*/ VIEW PART OF DATA /*/;

DATA MainWide;
	SET MainWide (DROP = _NAME_);
	RENAME _2021 = RBirth2021 _2023 = RBirth2023; /*/ DROP EXTRA VARIABLES /*/;
RUN;

PROC PRINT DATA = MainWide;
	WHERE StName = "Delaware";
RUN; /*/ VIEW PART OF DATA /*/;

/*/ Q 12 /*/;
 DATA MainWide;
		SET MainWide;
		RBirthDiff = RBirth2023 - RBirth2021; /*/ CREATE NEW VARIABLE /*/;
RUN;

PROC SORT DATA = MainWide OUT = MainWide;
	BY descending RBirthDiff;
RUN; /*/ SORT IN DESCENDING ORDER/*/;

PROC PRINT DATA = MainWide;
	WHERE StName = "Delaware";
RUN; /*/ VIEW PART OF DATA /*/;
