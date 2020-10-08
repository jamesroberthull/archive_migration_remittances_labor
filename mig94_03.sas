*********************************************************************
**     Program Name: /home/jrhull/ma/mig94_03.sas
**     Programmer: james r. hull
**     Start Date: 2005 September 19
**     Purpose:
**        1.) Descriptive Analysis
**        2.) Modifications before creating final data set for transfer
**     Input Data:
**        1.) '/trainee/jrhull/ma/help9403.xpt'
**     Output Data:
**        1.)
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 'Descriptive Analysis: Checking Variables for bad data and distributions';

*------------------*
*  Data Libraries  *
*------------------*;

libname in94_1 xport '/trainee/jrhull/ma/help9403.xpt';
libname in94_2 xport '/nangrong/data_sas/1994/current/indiv94.04';

*--------------------------------------------------*
* Frequencies, Means, and Std. Dev's for Variables *
*--------------------------------------------------*;

proc freq data=in94_1.help9403 (drop=HHID84 HHID94 HOUSE84 LEKTI84 LEKTI94
                                     VILL84 VILL94 MEANAGE AGETOTAL);
     tables HELP23A*HELPVA*HELPOA;       *** Remove this line to produce freq's for all variables ***;
     tables V_WAGE:;
     tables NUMMIGT MIGREM_Y MIGREM_N;

run;

*** Generate means for total sample ***;

/* proc means data=in94_1.help9403;
     vars AGETOTAL BUFFALO CASSAVA COWS F_13_65 HELPOB HELPVB HH_RAI M_13_65 MEANAGE NUM:
          LOWEST MIDDLE HIGHEST SILK SILKWORM CLOTH CHARCOAL COTTAGE PIGS MISSMIG RECMIG
          VILL1365 VILL_RAI VILL_WAF VILL_WAM HELP23B HELPOB HELPOH HELPVB HELPVH TOTHELP
          V_WAGE:;
run;    */

/* proc sort data=in94_1.help9403 out=help9403s2;
     by HELPDV2;
run;

proc means data=help9403s2 n mean std fw=4;
     vars AGETOTAL BUFFALO CASSAVA COWS F_13_65 HELPOB HELPVB HH_RAI M_13_65 MEANAGE NUM:
          LOWEST MIDDLE HIGHEST SILK SILKWORM CLOTH CHARCOAL COTTAGE PIGS MISSMIG RECMIG
          VILL1365 VILL_RAI VILL_WAF VILL_WAM HELP23B HELPOB HELPOH HELPVB HELPVH TOTHELP;
     by HELPDV2;
run; */

/* proc sort data=in94_1.help9403 out=help9403s3;
     by HELPDV;
run;

proc means data=help9403s3 n mean std fw=4;
     vars AGETOTAL BUFFALO CASSAVA COWS F_13_65 HELPOB HELPVB HH_RAI M_13_65 MEANAGE NUM:
          LOWEST MIDDLE HIGHEST SILK SILKWORM CLOTH CHARCOAL COTTAGE PIGS MISSMIG RECMIG
          VILL1365 VILL_RAI VILL_WAF VILL_WAM HELP23B HELPOB HELPOH HELPVB HELPVH TOTHELP;
     by HELPDV;
run; */

*** Additional analyses ***;

/* proc freq data=in94_1.help9403;
     tables VILL94*HELPDV VILL94*HELPDV2 VILL94*VILL_MIG/ nopercent nofreq nocol;
     tables CODETWO NUMMIGT;
     tables (NUMRRCD2 NUMRSND2)*NUMMIGT;
     tables HELPDV2;
     tables (NUMRRCD2 NUMRSND2)*HELPDV2;
     tables NUMMIGT*HELPDV;
run; */

proc freq data=in94_2.indiv94;
     tables HHTYPE94*Q1;
run;
