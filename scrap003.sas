*********************************************************************
**     Program Name: /home/jrhull/ma/des00_02.sas
**     Programmer: james r. hull
**     Start Date: 2005 April 10
**     Purpose:
**        1.) Check the newly created dataset rhelp_11 for integrity
**            by comparing it to a random sample of cases from the
**            original datasets that comprise its component variables
**     Input Data:
**        1.) /home/jrhull/ma/rhelp_11.xpt
**
*********************************************************************;

***************
**  Options  **
***************;

options nocenter linesize=80 pagesize=60;

title1 'Program to check integrity of data in rhelp_01';

**********************
**  Data Libraries  **
**********************;

libname in1 xport '/home/jrhull/ma/rhelp_11.xpt';
libname in2 xport '/nangrong/data_sas/2000/current/hh00.03';

*********************************************************
** choose a random sample of original cases from hh94  **
*********************************************************;

data smp5pct (keep=vill00 house00 hhid00 vill94 hhid94
        vill84 house84 rice x6_81 x6_82 x6_83
        x6_84 x6_84c: x6_84w: x6_85 x6_85h: x6_85n: x6_85w:
        x6_86 x6_86l: x6_86n: x6_86w: x6_87a1 x6_87a2 x6_87a3);
     set in2.hh00;
     if ranuni(4321) <.05;
run;

proc sort data=smp5pct;
   by hhid00;
run;

data testfile (keep=vill00 house00 hhid00 vill94 hhid94
        vill84 house84 rice x6_81 x6_82 x6_83
        x6_84 x6_84c: x6_84w: x6_85 x6_85h: x6_85n: x6_85w:
        x6_86 x6_86l: x6_86n: x6_86w: x6_87a1 x6_87a2 x6_87a3);
     set in1.rhelp_11
        smp5pct;
run;

proc sort data=testfile out=testfile2 noduprecs;
    by hhid00;
run;
