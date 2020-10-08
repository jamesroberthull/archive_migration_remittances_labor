*********************************************************************
**     Program Name: /home/jrhull/ma/des94_02.sas
**     Programmer: james r. hull
**     Start Date: 2005 March 5
**     Purpose:
**        1.) Check the newly created dataset rhelp_01 for integrity
**            by comparing it to a random sample of cases from the
**            original datasets that comprise its component variables
**     Input Data:
**        1.) /home/jrhull/ma/rhelp_01.xpt
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

libname in1 xport '/home/jrhull/ma/rhelp_01.xpt';
libname in2 xport '/nangrong/data_sas/1994/current/hh94.02';
libname in3 xport '/nangrong/data_sas/1994/current/helprh94.01';

*********************************************************
** choose a random sample of original cases from hh94  **
*********************************************************;

data smp5pct (keep=hhid94 vill94 lekti94 hhid84 house84
    vill84 hhtype94 lekti84 Q6_16 Q6_17 Q6_18 Q6_19 Q6_20
    Q6_21 Q6_22 Q6_23 Q6_23A1 Q6_23B1 Q6_23C1 Q6_23D1 Q6_23A2
    Q6_23B2 Q6_23C2 Q6_23D2 Q6_23A3 Q6_23B3 Q6_23C3 Q6_23D3
    Q6_23A4 Q6_23B4 Q6_23C4 Q6_23D4 Q6_23A5 Q6_23B5 Q6_23C5 Q6_23D5);

    set in2.hh94;
    if ranuni(4321) <.05 then output;
run;

proc sort data=smp5pct;
   by hhid94;
run;

data testfile (keep=hhid94 vill94 lekti94 hhid84 house84
    vill84 hhtype94 lekti84 Q6_16 Q6_17 Q6_18 Q6_19 Q6_20
    Q6_21 Q6_22 Q6_23 Q6_23A1 Q6_23B1 Q6_23C1 Q6_23D1 Q6_23A2
    Q6_23B2 Q6_23C2 Q6_23D2 Q6_23A3 Q6_23B3 Q6_23C3 Q6_23D3
    Q6_23A4 Q6_23B4 Q6_23C4 Q6_23D4 Q6_23A5 Q6_23B5 Q6_23C5 Q6_23D5);

    set in1.rhelp_01
        smp5pct;
run;

proc sort data=testfile out=testfile2 noduprecs;
    by hhid94;
run;
