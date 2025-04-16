LIBNAME myfolder "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework5";

/*/ QUESTION 1A /*/;
LIBNAME XP XPORT "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework5\demo_l.xpt";

DATA mydata;
SET XP.demo_l;
RUN;

PROC CONTENTS DATA = mydata VARNUM;
RUN;

/*/ QUESTION 1B /*/;
%MACRO xptimport(file=);
LIBNAME XP XPORT "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_to_Stats_Computing\Homework5\&file..xpt";

PROC COPY IN=xp OUT=work;
RUN;

PROC CONTENTS DATA = &file VARNUM;
RUN;
%MEND;

/*/ QUESTION 1C /*/;
%xptimport(file=demo_l);
%xptimport(file=inq_l);
%xptimport(file=hiq_l);
%xptimport(file=cbc_l);
%xptimport(file=bmx_l);

/*/ QUESTION 2 /*/;
%MACRO procsort(data=);
PROC SORT DATA = &data OUT = &data;
	BY SEQN;
RUN; 
%MEND;
%procsort(data=demo_l);
%procsort(data=inq_l);
%procsort(data=hiq_l);
%procsort(data=cbc_l);
%procsort(data=bmx_l);

DATA MergeData;
	MERGE demo_l inq_l hiq_l cbc_l bmx_l;
	BY SEQN; /*/ MERGE DATA BY SEQN /*/;
RUN;

PROC CONTENTS DATA = MergeData Varum;
RUN;

/*/ QUESTION 3 ID VARIABLES WITH MISSING VALUES AND MAKE FREQ TABLES OF EACH VARIABLE /*/;
/*/MISSING VARIABLES BASED ON MY SEARCH (LINK ON HOMEWORK GOES TO PAGE NOT FOUND) 
DMDBORN4 DMDYRUSR DMDEDUC2 DMDMARTZ DMQMILIZ
INQ300 IND310 INDFMMPC HIQ011 HIQ032A HIQ210 /*/;
PROC FREQ DATA = MergeData;
	TABLE IND310;
RUN;

%MACRO procfreq(vbl=);
PROC FREQ DATA = MergeData;
	TABLE &vbl.;
RUN;
%MEND;

%procfreq(vbl=DMDBORN4); /*/ 0 observations for 99 "don't know" and 77 "refused" /*/;
%procfreq(vbl=DMDYRUSR); /*/ 77 99 /*/;
%procfreq(vbl=DMDEDUC2); /*/ 7 9 /*/;
%procfreq(vbl=DMDMARTZ); /*/ 77 99 /*/;
%procfreq(vbl=DMQMILIZ); /*/ 7 9 /*/;
%procfreq(vbl=INQ300); /*/ 7 9 /*/;
%procfreq(vbl=IND310); /*/ 77 99 /*/;
%procfreq(vbl=INDFMMPC); /*/ 7 9 /*/;
%procfreq(vbl=HIQ011); /*/ 7 9 /*/;
%procfreq(vbl=HIQ032A); /*/ 77 99 /*/;
%procfreq(vbl=HIQ210); /*/ 7 9 /*/;

/*/ QUESTION 4 CREATE NEW VARIABLE THAT REPLACES MISSING VALUES WITH "." /*/;
DATA MergeData; 
SET MergeData;
ARRAY var (*) DMDEDUC2 DMQMILIZ INQ300 INDFMMPC HIQ011 HIQ210;
ARRAY newvar (*) xDMDEDUC2 xDMQMILIZ xINQ300 xINDFMMPC xHIQ011 xHIQ210;
DO i = 1 TO DIM(newvar);
newvar(i) = var(i);
IF newvar(i) IN(7,9) THEN newvar(i)=.;
END;
DROP i;
RUN; /*/ 84 variables to 90 after this step /*/;


DATA MergeData; 
SET MergeData;
ARRAY var (*) DMDBORN4 DMDYRUSR DMDMARTZ IND310 HIQ032A;
ARRAY newvar (*) xDMDBORN4 xDMDYRUSR xDMDMARTZ xIND310 xHIQ032A;
DO i = 1 TO DIM(newvar);
newvar(i) = var(i);
IF newvar(i) IN(77,99) THEN newvar(i)=.;
END;
DROP i;
RUN; /*/ 90 variables to 95 after this step /*/;

/*/ QUESTION 5 REPLACE ORIGINAL VARIABLES WITH NEW VARIABLE FROM Q4 /*/;
DATA MergeData; 
	SET MergeData;
	DROP DMDBORN4 DMDYRUSR DMDMARTZ IND310 HIQ032A DMDEDUC2 
DMQMILIZ INQ300 INDFMMPC HIQ011 HIQ210;
RUN; /*/ 95 variables to 84 after this step /*/;

/*/ QUESTION 6 CREATE 21 BOXPLOTS FOR THE COMPLETE BLOOD COUNT DATASET /*/;
ODS GRAPHICS ON/ HEIGHT= 3IN WIDTH= 2IN;
PROC SGPLOT DATA= MergeData;
VBOX LBXWBCSI;
RUN;



%MACRO vbox(vble=);
TITLE "Boxplot of &vble.";
PROC SGPLOT DATA= MergeData;
VBOX &vble.;
RUN;
TITLE;
%MEND; 

%vbox(vble=LBXWBCSI); 

%vbox(vble=LBXLYPCT);
 
%vbox(vble=LBXMOPCT);

%vbox(vble=LBXNEPCT);
 
%vbox(vble=LBXEOPCT);
 
%vbox(vble=LBXBAPCT);

%vbox(vble=LBDLYMNO);
 
%vbox(vble=LBDMONO);
 
%vbox(vble=LBDNENO);

%vbox(vble=LBDBANO);
 
%vbox(vble=LBXRBCSI);

%vbox(vble=LBXHGB);

%vbox(vble=LBXHCT); 

%vbox(vble=LBXMCVSI);

%vbox(vble=LBXMC);

%vbox(vble=LBXMCHSI); 

%vbox(vble=LBXRDW); 

%vbox(vble=LBXMPSI);

%vbox(vble=LBXNRBC);
 
%vbox(vble=LBDEONO);

%vbox(vble=LBXPLTSI);


ODS LAYOUT GRIDDED COLUMNS = 7;

ODS REGION;
%vbox(vble=LBXWBCSI); 
ODS REGION;
%vbox(vble=LBXLYPCT); 
ODS REGION;
%vbox(vble=LBXMOPCT);
ODS REGION;
%vbox(vble=LBXNEPCT); 
ODS REGION;
%vbox(vble=LBXEOPCT); 
ODS REGION;
%vbox(vble=LBXBAPCT);
ODS REGION;
%vbox(vble=LBDLYMNO); 
ODS REGION;
%vbox(vble=LBDMONO); 
ODS REGION;
%vbox(vble=LBDNENO);
ODS REGION;
%vbox(vble=LBDBANO); 
ODS REGION;
%vbox(vble=LBXRBCSI);
ODS REGION;
%vbox(vble=LBXHGB);
ODS REGION;
%vbox(vble=LBXHCT); 
ODS REGION;
%vbox(vble=LBXMCVSI);
ODS REGION;
%vbox(vble=LBXMC);
ODS REGION;
%vbox(vble=LBXMCHSI); 
ODS REGION;
%vbox(vble=LBXRDW); 
ODS REGION;
%vbox(vble=LBXMPSI);
ODS REGION;
%vbox(vble=LBXNRBC); 
ODS REGION;
%vbox(vble=LBDEONO); 
ODS REGION;
%vbox(vble=LBXPLTSI);

ODS LAYOUT END;

ODS GRAPHICS /RESET;

/*/ QUESTION 7 CREATE A SCATTER MATRIX FOR VARIABLES IN THE BMX DATASET /*/;

%MACRO scatterm(data=, vars=); 
  PROC SGSCATTER DATA = &data; 
  WHERE RIDAGEYR > 18;
  MATRIX &vars;  
  RUN; 
%MEND; 

%scatterm(data=MergeData, vars= BMXWT BMXHT BMXBMI
BMXLEG BMXARML BMXARMC BMXWAIST BMXHIP);
