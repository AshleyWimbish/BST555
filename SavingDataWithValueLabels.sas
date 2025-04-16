************************************************************************
*  Intro to Statistical Computing with SAS
*  Demonstration of how to save dataset with value labels
*  and open it without an error
************************************************************************;


** Open the dataset *****;

** Set LIBNAME;
LIBNAME myfolder "C:\Users\aw3587\OneDrive - Drexel University\Fall_24\Intro_Stats_Computing\Homework1";

** Open the cleaned dataset, but I cannot because SAS cannot find the formats;
DATA mydata;
	SET myfolder.clean_heart;
RUN;

** Suppress such an error;
OPTIONS NOFMTERR;

** Open the cleaned dataset. Now I can;
DATA mydata;
	SET myfolder.heart_clean;
RUN;

** Create a frequency table. But it is not labeled;
PROC FREQ DATA = mydata;
	TABLE Sex;
RUN;

** Create value labels, but save it permanently;
PROC FORMAT LIBRARY = myfolder;
	VALUE sex
		1 = "Male"
		2 = "Female";
RUN;

** Tell SAS where to look for the value labels;
OPTIONS FMTSEARCH=(myfolder WORK);


** Attach the value labels;
DATA mydata;
	SET mydata;
	FORMAT Sex sex.;
RUN;

PROC FREQ DATA = mydata;
	TABLE Sex;
RUN;


** Save the dataset;
DATA myfolder.heart_clean2;
	SET mydata;
RUN;

** Return to the default setting;
OPTIONS FMTERR;
OPTIONS FMTSEARCH=(WORK);





** Open the dataset *****;

** Set LIBNAME;
LIBNAME myfolder "C:\Users\goroy\OneDrive - Drexel University\Drexel_Teaching\BST555_SAS\Homework1";

** Tell SAS where to look for the value labels;
OPTIONS FMTSEARCH=(myfolder WORK);

** Open the dataset;
DATA mydata2;
	SET myfolder.heart_clean2;
RUN;

** The data is already labeled;
PROC FREQ DATA = mydata2;
	TABLE Sex;
RUN;
