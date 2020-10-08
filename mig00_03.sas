*********************************************************************
**     Program Name: /home/jrhull/ma/mig00_03.sas
**     Programmer: james r. hull
**     Start Date: 2005 September 19
**     Purpose:
**        1.) Descriptive Analysis
**        2.) Check for bad data and distributions before transfer
**     Input Data:
**        1.) '/trainee/jrhull/ma/help0003.xpt'
**     Output Data:
**        1.) '/trainee/jrhull/ma/help0004.xpt'
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 'Creating Control Variables: 2000 migration data';

*------------------*
*  Data Libraries  *
*------------------*;

libname in00_1 xport '/trainee/jrhull/ma/help0003.xpt';
libname in00_2 xport '/nangrong/data_sas/2000/current/indiv00.03';

*--------------------------------------------------*
* Frequencies, Means, and Std. Dev's for Variables *
*--------------------------------------------------*;

proc freq data=in00_1.help0003 (drop=HHID00 HHID94 HOUSE00 HOUSE84 VILL00 VILL84 VILL94 AGETOTAL MEANAGE);
     tables HELP23A*HELPVA*HELPOA;           *** Remove this line to produce freq's for all variables ***;
     tables V_WAGE:;
     tables NUMMIGT MIGREM_Y MIGREM_N;
run;

*** Generate means for total sample ***;

/* proc means data=in00_1.help0003;
     vars AGETOTAL BUFFALO CASSAVA COWS F_13_65 HELPOB HELPVB HH_RAI M_13_65 MEANAGE NUM:
          LOWEST MIDDLE HIGHEST SILK SILKWORM CLOTH CHARCOAL COTTAGE PIGS MISSMIG RECMIG
          VILL1365 VILL_RAI VILL_WAF VILL_WAM HELP23B HELPOB HELPOH HELPVB HELPVH TOTHELP
          V_WAGE:;
run;   */

/* proc sort data=in00_1.help0003 out=help0003s2;
     by HELPDV2;
run;

proc means data=help0003s2 n mean std fw=4;
     vars AGETOTAL BUFFALO CASSAVA COWS F_13_65 HELPOB HELPVB HH_RAI M_13_65 MEANAGE NUM:
          LOWEST MIDDLE HIGHEST SILK SILKWORM CLOTH CHARCOAL COTTAGE PIGS MISSMIG RECMIG
          VILL1365 VILL_RAI VILL_WAF VILL_WAM HELP23B HELPOB HELPOH HELPVB HELPVH TOTHELP;
     by HELPDV2;
run; */

/* proc sort data=in00_1.help0003 out=help0003s3;
     by HELPDV;
run;

proc means data=help0003s3 n mean std fw=4;
     vars AGETOTAL BUFFALO CASSAVA COWS F_13_65 HELPOB HELPVB HH_RAI M_13_65 MEANAGE NUM:
          LOWEST MIDDLE HIGHEST SILK SILKWORM CLOTH CHARCOAL COTTAGE PIGS MISSMIG RECMIG
          VILL1365 VILL_RAI VILL_WAF VILL_WAM HELP23B HELPOB HELPOH HELPVB HELPVH TOTHELP;
     by HELPDV;
run; */

*** Additional analyses ***;

/* proc freq data=in00_1.help0003;
     tables VILL94*HELPDV VILL94*HELPDV2 VILL94*VILL_MIG/ nofreq nopercent nocol;
     tables CODETWO NUMMIGT;
     tables (NUMRRCD2 NUMRSND2)*NUMMIGT;
     tables HELPDV2;
     tables (NUMRRCD2 NUMRSND2)*HELPDV2;
     tables NUMMIGT*HELPDV;
run; */

proc freq data=in00_2.indiv00;
     tables HHTYPE00*X1;
run;
