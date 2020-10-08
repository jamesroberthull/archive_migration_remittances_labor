*********************************************************************
**     Program Name: /trainee/jrhull/ma/migm9400.sas
**     Programmer: james r. hull
**     Start Date: 2006 January 21
**     Purpose:
**        1.) Match-merge 1994 and 2000 data sets
**     Input Data:
**        2.) /trainee/jrhull/ma/merge94.xpt
**        4.) /trainee/jrhull/ma/merge00.xpt
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

*------------------*
*  Data Libraries  *
*------------------*;

libname in94_1 xport '/trainee/jrhull/ma/merge94.xpt' ;
libname in00_1 xport '/trainee/jrhull/ma/merge00.xpt' ;

libname out1 xport '/trainee/jrhull/ma/merg9400.xpt';

*-------------------------------------------*
* Generate pre-merge descriptive statistics *
*-------------------------------------------*;

proc freq data=in94_1.merge94;
     tables hhtype94;
     /* tables (numrcd94 numsnd94)*nummig94 / nopercent norow nocol;  */
run;

proc freq data=in00_1.merge00;
     tables hhtype00;
     /* tables (numrcd00 numsnd00)*nummig00 / nopercent norow nocol;  */
run;

*------------------------------*
* Merge 1994 and 2000 datasets *
*------------------------------*;

proc sort data=in00_1.merge00 out=merge00;
     by vill94 hhid94;
run;

data merg9400 no94data no00data;
     merge in94_1.merge94 (in=a)
           merge00 (in=b);
     by vill94 hhid94;

     if a=1 and b=1 then output merg9400;
     if a=1 and b=0 then output no00data;
     if a=0 and b=1 then output no94data;
run;

proc freq data=merg9400;
     tables hhtype94 hhtype00;
     /* tables (code2_00 nummig00)*hhtype94; */
     tables helpd294*helpd200 helpd194*helpd100;
run;

data out1.merg9400;
     set merg9400;
run;

data merg94_2;
     set in94_1.merge94;
     if hhtype94 in (1,3);
run;

data merg00_2;
     set merge00;
     if hhtype00 in (1,3);
run;

proc freq data=merg94_2;
     tables hhtype94;
run;

proc freq data=merg00_2;
     tables hhtype00;
run;

data mergdat2 no94_2 no00_2;
     merge merg94_2 (in=a)
           merg00_2 (in=b);
     by vill94 hhid94;

     if a=1 and b=1 then output mergdat2;
     if a=1 and b=0 then output no00_2;
     if a=0 and b=1 then output no94_2;

run;

proc freq data=mergdat2;
     tables hhtype94 hhtype00;
     /* tables (code2_00 nummig00)*hhtype94; */
     tables helpd294*helpd200 helpd194*helpd100;
run;
