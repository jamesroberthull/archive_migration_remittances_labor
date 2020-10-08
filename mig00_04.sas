*********************************************************************
**     Program Name: /home/jrhull/ma/mig00_04.sas
**     Programmer: james r. hull
**     Start Date: 2006 February 15
**     Purpose:
**        1.) Additional Village-Level Analysis
**
**     Input Data:
**        1.) '/trainee/jrhull/ma/help0003.xpt'
**     Output Data:
**        1.)
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 'Additional Analysis: Village-Level Relationship between Migration and Yields';

*------------------*
*  Data Libraries  *
*------------------*;

libname in00_1 xport '/trainee/jrhull/ma/help0003.xpt';

proc sort data=in00_1.help0003 out=work00_0;
     by VILL84;
run;

data work00_1 (keep=VILL84 VILL_MIG VILL_YLD VILL_ADS VILL_LND VILL_HH VILL_RCD VILL_SND);
     set work00_0;
     by VILL84;

     keep VILL84 VILL_MIG VILL_YLD VILL_ADS VILL_LND VILL_HH VILL_RCD VILL_SND;

     retain VILL_MIG VILL_YLD VILL_ADS VILL_LND VILL_HH VILL_RCD VILL_SND;

     if first.VILL84 then do;                                /* Change between VILL84 and VILL94 */
                            VILL_MIG=0;
                            VILL_YLD=0;
                            VILL_LND=VILL_RAI;
                            VILL_ADS=VILL1365;
                            VILL_HH=0;
                            VILL_RCD=0;
                            VILL_SND=0;
                          end;

     if NUMMIGT ne . then VILL_MIG=VILL_MIG+NUMMIGT;    /* Number of pre-harvest migrants at village level */
        else VIL_MIG=VIL_MIG;

     if RICE_YLD ne . then VILL_YLD=VILL_YLD+RICE_YLD;    /* Total rice yield at village level */
        else VILL_YLD=VILL_YLD;

     if NUMRRCD2 ne . then VILL_RCD=VILL_RCD+NUMRRCD2;
        else VILL_RCD=VILL_RCD;

     if NUMRSND2 ne . then VILL_SND=VILL_SND+NUMRSND2;
        else VILL_SND=VILL_SND;

     VILL_HH=VILL_HH+1;

     if last.VILL84 then output;

run;

data work00_2;
     set work00_1;
     MIG_RAT=VILL_MIG/VILL_ADS;
     VILL_MHH=VILL_MIG/VILL_HH;
run;

proc print data=work00_2;
     by VILL84;
     var VILL_MIG VILL_YLD VILL_ADS VILL_LND MIG_RAT VILL_HH VILL_MHH VILL_RCD VILL_SND;
run;

proc corr data=work00_2;
     var VILL_YLD VILL_MIG VILL_ADS VILL_LND MIG_RAT VILL_HH VILL_MHH VILL_RCD VILL_SND;
run;

/* proc means data=work00_2;
     var VILL_MIG VILL_YLD VILL_ADS VILL_LND MIG_RAT;
run;

proc corr data=work00_2;
     var VILL_YLD VILL_MIG;
run;

proc reg data=work00_2;
     model VILL_YLD=VILL_MIG;
run;

proc reg data=work00_2;
     model VILL_YLD=VILL_MIG VILL_ADS VILL_LND;
run;

proc reg data=work00_2;
     model VILL_YLD=MIG_RAT;
run;

proc reg data=work00_2;
     model VILL_YLD=MIG_RAT VILL_LND;
run; */
