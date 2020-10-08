*********************************************************************
**     Program Name: /home/jrhull/ma/mig94_01.sas
**     Programmer: james r. hull
**     Start Date: 2005 June 19
**     Purpose:
**        1.) Create migration variable
**        2.) Produce basic descriptive statistics on these variables
**     Input Data:
**        1.) '/nangrong/data_sas/1994/current/hh94.03'
**        2.) '/nangrong/data_sas/1994/current/indiv94.03'
          3.) '/trainee/jrhull/ma/help9401.xpt'
**     Output Data:
**        1.) '/trainee/jrhull/ma/help9402.xpt'
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 'Descriptive analysis: 1994 migration data';

*------------------*
*  Data Libraries  *
*------------------*;

libname in94_1 xport '/nangrong/data_sas/1994/current/hh94.03';
libname in94_2 xport '/nangrong/data_sas/1994/current/indiv94.03';
libname in94_3 xport '/trainee/jrhull/ma/help9401.xpt';

libname out94_1 xport '/trainee/jrhull/ma/help9402.xpt';

*-------------------------*
*  Merge INDIV00 to HH00  *
*-------------------------*;

***Note: this becomes an individual-level file***;

data work94_1;
     merge in94_1.hh94(keep=HHID94 VILL94 DATE in=a)
           in94_2.indiv94(keep=HHID94 VILL94 LEKTI94 CEP94 Q1 Q3 Q27 Q29 Q30: Q31 Q33 Q34: Q10D Q10M Q10Y in=b);
     by HHID94;

     if (a=1 and b=1) and (Q1=3);

     DATECHAR=right(put(DATE,6.));

     if substr(DATECHAR,1,1)=' ' then substr(DATECHAR,1,1)='0';

*** Create YEAR, MONTH, and DAY ***;

     DAY=substr(DATECHAR,1,2);
     MONTH=substr(DATECHAR,3,2);
     YEAR=1994;

*** Create IDATE, HDATE DDATE ***;

      if MONTH in ("99","  ") or DAY in ("99","  ") then IDATE=.;        /* IDATE = interview date */
         else IDATE=MDY(MONTH,DAY,YEAR);

      HDATE=MDY(10,1,1993);                                              /* HDATE = Harvest begins */

      if IDATE=. or HDATE=. then DDATE=.;
         else DDATE=IDATE-HDATE;                                         /* DDATE = Difference in # days */

*** Transform DDATE to months ***;
                                                                         /* DMONTH = # days rounded */
      if DDATE=. then DMONTH=.;
         else DMONTH=round(DDATE/30);

*** Create # Days Away ***;

      if (Q10D in (98,99) or Q10M in (98,99) or Q10Y in (98,99)) or (Q10M=. and Q10Y=.) then DAYSGONE=99999;
         else if (Q10D=. and Q10Y ne .) then DAYSGONE=(Q10Y*365);
         else DAYSGONE=Q10D+(Q10M*30)+(Q10Y*365);

*** Round # days gone to months ***;

      if Q10D=99 then MOROUND=9;
         else if Q10D=. then MOROUND=.;
         else if Q10D<16 then MOROUND=0;
         else if Q10D>=16 then MOROUND=1;

*** Create variable # months gone ***;

      if (Q10D in (98,99) or Q10M in (98,99) or Q10Y in (98,99)) or (Q10M=. and Q10Y=.) then MOGONE=9999;
         else if (Q10D=. and Q10Y ne .) then MOGONE=(Q10Y*12);
         else MOGONE=MOROUND+Q10M+(Q10Y*12);

*** Create variable # years gone ***;   /* This was created especially for the cross-tab with Q27 & Q31 below */

     if MOGONE < 12 then YRGONE=0;
        else if MOGONE > 11 and MOGONE < 24 then YRGONE=1;
        else if MOGONE > 23 and MOGONE < 36 then YRGONE=2;
        else if MOGONE > 35 and MOGONE < 48 then YRGONE=3;
        else if MOGONE > 47 and MOGONE < 60 then YRGONE=4;
        else if MOGONE > 59 and MOGONE < 72 then YRGONE=5;
        else if MOGONE > 71 and MOGONE < 84 then YRGONE=6;
        else if MOGONE > 83 and MOGONE < 96 then YRGONE=7;
        else if MOGONE > 95 and MOGONE < 108 then YRGONE=8;
        else if MOGONE > 107 and MOGONE < 120 then YRGONE=9;
        else if MOGONE > 119 and MOGONE < 132 then YRGONE=10;
        else if MOGONE > 131 and MOGONE < 144 then YRGONE=11;
        else if MOGONE > 143 and MOGONE < 156 then YRGONE=12;
        else if MOGONE > 155 and MOGONE < 168 then YRGONE=13;
        else if MOGONE > 167 and MOGONE < 9999 then YRGONE=14;
        else if MOGONE in (9999) then YRGONE=99;

*** Compare Months gone to time since 10/1/1999 ***;

      if MOGONE=9999 then RICEMIG=9;
         else if (MOGONE > DMONTH and MOGONE < 72) then RICEMIG=1;
         else RICEMIG=0;

*** A second variable usin 3 years as the cut-off, not 6 years ***;

      if MOGONE=9999 then RICEMIG2=9;
         else if (MOGONE > DMONTH and MOGONE < 36) then RICEMIG2=1;
         else RICEMIG2=0;

*** Create numeric equivalents (means) of remittances for aggregation ***;

      if Q29=1 then REMAMT=500;
         else if Q29=2 then REMAMT=2000;
         else if Q29=3 then REMAMT=4000;
         else if Q29=4 then REMAMT=7500;
         else if Q29=5 then REMAMT=15000;
         else if Q29=6 then REMAMT=20000;
         else REMAMT=0;

    if Q29 in (8,9) then Q29=0;                 /* These could be used to look at frequencies - need to be merged to final dataset */

    if Q33=1 then SNDAMT=500;
         else if Q33=2 then SNDAMT=2000;
         else if Q33=3 then SNDAMT=4000;
         else if Q33=4 then SNDAMT=7500;
         else if Q33=5 then SNDAMT=15000;
         else if Q33=6 then SNDAMT=20000;
         else SNDAMT=0;

    if Q33 in (8,9) then Q33=0;                 /* These could be used to look at frequencies - need to be merged to final dataset */

run;

*** Frequency ***;

proc freq data=work94_1;
     /*tables DAY MONTH YEAR IDATE HDATE DDATE DMONTH Q10D Q10M Q10Y DAYSGONE MOGONE RICEMIG; */
     tables YRGONE*(Q27 Q31);
run;

*** Print ***;

/*proc print data=work94_1(obs=500);
     id HHID94 CEP94;
     var Q10D MOROUND Q10M Q10Y DMONTH MOGONE RICEMIG;
run;  */

data work94_2;
     set work94_1 (keep=HHID94 Q3 Q27 Q29 Q30: Q31 Q33 Q34: REMAMT SNDAMT RICEMIG RICEMIG2);

     by HHID94;

     keep HHID94 NUMMIGM NUMMIGF NUMMIGT NUMMIGT2 RECMIG RECMIG2
          MISSMIG MISSMIG2 NUMRRCD2 NUMRRCD3 NUMRSND2 NUMRSND3 NUMREMIT NUMREMSD
          REM_ND2 REM_ND3 SREM_ND2 SREM_ND3 TOTRRCD2 TOTRRCD3 TOTRSND2 TOTRSND3 MIGREM_Y MIGREM_N;

     retain NUMMIGM NUMMIGF NUMMIGT NUMMIGT2 RECMIG RECMIG2
            MISSMIG MISSMIG2 NUMRRCD2 NUMRRCD3 NUMRSND2 NUMRSND3 NUMREMIT NUMREMSD
            REM_ND2 REM_ND3 SREM_ND2 SREM_ND3 TOTRRCD2 TOTRRCD3 TOTRSND2 TOTRSND3 MIGREM_Y MIGREM_N;

     if first.HHID94 then do;
                            NUMMIGM=0;
                            NUMMIGF=0;
                            NUMMIGT=0;
                            NUMMIGT2=0;
                            RECMIG=0;
                            RECMIG2=0;
                            MISSMIG=0;
                            MISSMIG2=0;
                            NUMREMIT=0;
                            NUMREMSD=0;
                            NUMRRCD2=0;
                            NUMRRCD3=0;
                            NUMRSND2=0;
                            NUMRSND3=0;
                            REM_ND2=0;
                            REM_ND3=0;
                            SREM_ND2=0;
                            SREM_ND3=0;
                            TOTRRCD2=0;
                            TOTRRCD3=0;
                            TOTRSND2=0;
                            TOTRSND3=0;
                            MIGREM_Y=0;
                            MIGREM_N=0;
                          end;

     if (Q27=1 OR Q30A=1 OR Q30B=1 OR Q30C=1 OR Q30D=1 OR Q30E=1) then NUMREMIT=NUMREMIT+1;
     if (Q31=1 OR Q34A=1 OR Q34B=1 OR Q34C=1 OR Q34D=1 OR Q34E=1) then NUMREMSD=NUMREMSD+1;

     if RICEMIG=1 and (Q27=1 OR Q30A=1 OR Q30B=1 OR Q30C=1 OR Q30D=1 OR Q30E=1) then NUMRRCD2=NUMRRCD2+1;
        else if Q27=9 then REM_ND2=1;

     if RICEMIG=1 and (Q31=1 OR Q34A=1 OR Q34B=1 OR Q34C=1 OR Q34D=1 OR Q34E=1) then NUMRSND2=NUMRSND2+1;
        else if Q31=9 then SREM_ND2=1;

     if RICEMIG2=1 and (Q27=1 OR Q30A=1 OR Q30B=1 OR Q30C=1 OR Q30D=1 OR Q30E=1) then NUMRRCD3=NUMRRCD3+1;
        else if Q27=9 then REM_ND3=1;

     if RICEMIG2=1 and (Q31=1 OR Q34A=1 OR Q34B=1 OR Q34C=1 OR Q34D=1 OR Q34E=1) then NUMRSND3=NUMRSND3+1;
        else if Q31=9 then SREM_ND3=1;

     if RICEMIG=1 and Q3=1 then NUMMIGM=NUMMIGM+1;
        else if RICEMIG=1 and Q3=2 then NUMMIGF=NUMMIGF+1;

     if RICEMIG=1 then NUMMIGT=NUMMIGT+1;
        else if RICEMIG=0 then RECMIG=RECMIG+1;
        else if RICEMIG=9 then MISSMIG=MISSMIG+1;

     if RICEMIG2=1 then NUMMIGT2=NUMMIGT2+1;
        else if RICEMIG2=0 then RECMIG2=RECMIG2+1;
        else if RICEMIG2=9 then MISSMIG2=MISSMIG2+1;

     if RICEMIG=1 then TOTRRCD2=TOTRRCD2+REMAMT;

     if RICEMIG=1 then TOTRSND2=TOTRSND2+SNDAMT;

     if RICEMIG2=1 then TOTRRCD3=TOTRRCD3+REMAMT;

     if RICEMIG2=1 then TOTRSND3=TOTRSND3+SNDAMT;

     if RICEMIG=1 and (Q27=1 OR Q30A=1 OR Q30B=1 OR Q30C=1 OR Q30D=1 OR Q30E=1) then MIGREM_Y=MIGREM_Y+1;
        else if RICEMIG=1 then MIGREM_N=MIGREM_N+1;

     if last.HHID94 then output;
run;

proc freq data=work94_2;
     /* tables NUMMIG RECMIG MISSMIG; */
     tables NUMREMIT*NUMRRCD2 NUMREMSD*NUMRSND2;
run;

data work94_3 noricefile;
     merge work94_2 (in=a)
           in94_3.help9401 (in=b);
     by HHID94;
     if a=0 and b=1 then do;
                           NUMMIGT=0;
                           NUMMIGT2=0;
                           NUMMIGM=0;
                           NUMMIGF=0;
                           MISSMIG=0;
                           MISSMIG2=0;
                           RECMIG=0;
                           RECMIG2=0;
                           NUMREMIT=0;
                           NUMREMSD=0;
                           NUMRRCD2=0;
                           NUMRRCD3=0;
                           NUMRSND2=0;
                           NUMRSND3=0;
                           REM_ND2=0;
                           REM_ND3=0;
                           SREM_ND2=0;
                           SREM_ND3=0;
                           TOTRRCD2=0;
                           TOTRRCD3=0;
                           TOTRSND2=0;
                           TOTRSND3=0;
                           MIGREM_Y=0;
                           MIGREM_N=0;
                         end;

     /* if MISSMIG > 0 then NUMMIG=.; */ /*This line forces a stricter treatment of missing data */

     if b=1 then output work94_3;
     if a=1 and b=0 then output noricefile;

run;


proc contents data=work94_3 varnum;
run;

proc freq data=work94_3;
     title1 'Number of Migrants per HH';
     tables NUMMIGT NUMMIGM NUMMIGF;
     tables NUMMIGT*HELPDV2 / CHISQ;
     tables NUMMIGT2*HELPDV2 / CHISQ;
     /* tables TOTRRCD2*NUMRRCD2; */
     /* tables TOTRSND2*NUMRSND2; */
run;

proc corr data=work94_3;
     var TOTRRCD2 NUMRRCD2;
     var TOTRSND2 NUMRSND2;
     var TOTRRCD3 NUMRRCD3;
     var TOTRSND3 NUMRSND3;
run;

data out94_1.help9402;
     set work94_3;
run;

proc datasets;
     delete work94_1 work94_2 work94_3;
run;
