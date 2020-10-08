********************************************************************
**     Program Name: /home/jrhull/ma/mig00_01.sas
**     Programmer: james r. hull
**     Start Date: 2005 June 19
**     Purpose:
**        1.) Create variables needed to construct migration variable
**        2.) Produce basic descriptive statistics for these variables
**     Input Data:
**        1.) '/nangrong/data_sas/2000/current/indiv00.03'
**        2.) '/nangrong/data_sas/2000/current/hh00.04'
**        3.) '/trainee/jrhull/ma/help0001.xpt'
**     Output Data:
**        1.) '/trainee/jrhull/ma/help0002.xpt'
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options linesize=80 pagesize=60;

title1 'Descriptive analysis: 2000 migration data';

*------------------*
*  Data Libraries  *
*------------------*;

libname in00_1 xport '/nangrong/data_sas/2000/current/hh00.04';
libname in00_2 xport '/nangrong/data_sas/2000/current/indiv00.03';
libname in00_3 xport '/trainee/jrhull/ma/help0001.xpt';

libname out00_1 xport '/trainee/jrhull/ma/help0002.xpt';

*-------------------------*
*  Merge INDIV00 to HH00  *
*-------------------------*;

***Note: this becomes an individual-level file***;

data work00_1 (drop=i);
     merge in00_1.hh00(keep=HHID00 INTMNTH1-INTMNTH6 INTDAY1-INTDAY6 INTRES1-INTRES6 in=a)
           in00_2.indiv00(keep=HHID00 CEP00 X1 X4 X25 X26 X28 X29 CODE2 X7D X7M X7Y in=b);
     by HHID00;

     if (a=1 and b=1) and (X1=3);

*** Create MONTH and DAY ***;

     array iv1 {6} INTRES1-INTRES6;
     array iv2 {6} INTDAY1-INTDAY6;
     array iv3 {6} INTMNTH1-INTMNTH6;

     do i=1 to 6;
        if iv1{i}=1
           then do;
                  DAY=iv2{i};
                  MONTH=iv3{i};
                end;
     end;

     YEAR=2000;

*** Create IDATE, HDATE DDATE ***;

      if MONTH in (99,.) or DAY in (99,.) then IDATE=.;
         else IDATE=MDY(MONTH,DAY,YEAR);

      HDATE=MDY(10,1,1999);

      if IDATE=. or HDATE=. then DDATE=.;
         else DDATE=IDATE-HDATE;

*** Transform DDATE to months ***;

      if DDATE=. then DMONTH=.;
         else DMONTH=round(DDATE/30);

*** Create # Days Away ***;

      if (X7D=99 or X7M=99 or X7Y=99) or (X7M=. and X7Y=.) then DAYSGONE=99999;
         else if (X7D=. and X7Y ne .) then DAYSGONE=(X7Y*365);
         else DAYSGONE=X7D+(X7M*30)+(X7Y*365);

*** Round # days gone to months ***;

      if X7D=99 then MOROUND=9;
         else if X7D=. then MOROUND=.;
         else if X7D<16 then MOROUND=0;
         else if X7D>=16 then MOROUND=1;

*** Create variable # months gone ***;

      if (X7D=99 or X7M=99 or X7Y=99) or (X7M=. and X7Y=.) then MOGONE=999;
         else if (X7D=. and X7Y ne .) then MOGONE=(X7Y*12);
         else MOGONE=MOROUND+X7M+(X7Y*12);

*** Create variable # years gone ***;   /* This was created especially for the cross-tab with X25 & X28 below */

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
        else if MOGONE > 167 and MOGONE < 999 then YRGONE=14;
        else if MOGONE in (999) then YRGONE=99;

*** Compare Months gone to time since 10/1/1999 ***;

      if MOGONE=999 then RICEMIG=9;
         else if (MOGONE > DMONTH and MOGONE < 72) then RICEMIG=1;
         else RICEMIG=0;

*** A second variable usin 3 years as the cut-off, not 6 years ***;

       if MOGONE=999 then RICEMIG2=9;
         else if (MOGONE > DMONTH and MOGONE < 36) then RICEMIG2=1;
         else RICEMIG2=0;

*** Create numeric equivalents (means) of remittances for aggregation ***;

      if X26=1 then REMAMT=500;
         else if X26=2 then REMAMT=2000;
         else if X26=3 then REMAMT=4000;
         else if X26=4 then REMAMT=7500;
         else if X26=5 then REMAMT=15000;
         else if X26=6 then REMAMT=30000;
         else if X26=7 then REMAMT=40000;
         else REMAMT=0;

      if X26 in (.,9) then X26=0;          /* These could be used to look at frequencies - need to be merged to final dataset */

      if X29=1 then SNDAMT=500;
         else if X29=2 then SNDAMT=2000;
         else if X29=3 then SNDAMT=4000;
         else if X29=4 then SNDAMT=7500;
         else if X29=5 then SNDAMT=15000;
         else if X29=6 then SNDAMT=30000;
         else if X29=7 then SNDAMT=40000;
         else SNDAMT=0;

      if X29 in (.,9) then X29=0;          /* These could be used to look at frequencies - need to be merged to final dataset */

run;

*** Frequency ***;

proc freq data=work00_1;
     /* tables DAY MONTH YEAR IDATE HDATE DDATE DMONTH X7D X7M X7Y DAYSGONE MOGONE RICEMIG;*/
     tables YRGONE*(X25 X28);
run;

*** Print ***;

/* proc print data=work00_1(obs=500);
     id HHID00 CEP00;
     var X7D MOROUND X7M X7Y DMONTH MOGONE RICEMIG;
run; */

data work00_2;                                                                       /* Produces a HH-level data-file */
     set work00_1 (keep=HHID00 X4 X25 X28 X26 X29 REMAMT SNDAMT RICEMIG RICEMIG2);

     by HHID00;

     keep HHID00 NUMMIGM NUMMIGF NUMMIGT NUMMIGT2 RECMIG RECMIG2
          MISSMIG MISSMIG2 NUMRRCD2 NUMRRCD3 NUMRSND2 NUMRSND3 NUMREMIT NUMREMSD
          REM_ND2 REM_ND3 SREM_ND2 SREM_ND3 TOTRRCD2 TOTRRCD3 TOTRSND2 TOTRSND3 MIGREM_Y MIGREM_N;

     retain NUMMIGM NUMMIGF NUMMIGT NUMMIGT2 RECMIG RECMIG2
            MISSMIG MISSMIG2 NUMRRCD2 NUMRRCD3 NUMRSND2 NUMRSND3 NUMREMIT NUMREMSD
            REM_ND2 REM_ND3 SREM_ND2 SREM_ND3 TOTRRCD2 TOTRRCD3 TOTRSND2 TOTRSND3 MIGREM_Y MIGREM_N;

     if first.HHID00 then do;
                            NUMMIGT=0;
                            NUMMIGT2=0;
                            RECMIG=0;
                            RECMIG2=0;
                            MISSMIG=0;
                            MISSMIG2=0;
                            NUMMIGM=0;
                            NUMMIGF=0;
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

     if X25=1 then NUMREMIT=NUMREMIT+1;
     if X28=1 then NUMREMSD=NUMREMSD+1;

     if RICEMIG=1 and X25=1 then NUMRRCD2=NUMRRCD2+1;
        else if RICEMIG=1 and X25=9 then REM_ND2=1;

     if RICEMIG=1 and X28=1 then NUMRSND2=NUMRSND2+1;
        else if RICEMIG=1 and X28=9 then SREM_ND2=1;

     if RICEMIG2=1 and X25=1 then NUMRRCD3=NUMRRCD3+1;
        else if RICEMIG2=1 and X25=9 then REM_ND3=1;

     if RICEMIG2=1 and X28=1 then NUMRSND3=NUMRSND3+1;
        else if RICEMIG2=1 and X28=9 then SREM_ND3=1;

     if RICEMIG=1 and X4=1 then NUMMIGM=NUMMIGM+1;
        else if RICEMIG=1 and X4=2 then NUMMIGF=NUMMIGF+1;

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

     if RICEMIG=1 and X25=1 then MIGREM_Y=MIGREM_Y+1;
        else if RICEMIG=1 then MIGREM_N=MIGREM_N+1;

     if last.HHID00 then output;
run;

proc freq data=work00_2;
     /* tables NUMMIGT; */
     tables NUMREMIT*NUMRRCD2 NUMREMSD*NUMRSND2;
run;

data work00_3 noricefile;                            /* Merging HHs with migrants to all HHs */
     merge work00_2 (in=a)
           in00_3.help0001 (in=b);
     by HHID00;
     if a=0 and b=1 then do;
                            NUMMIGM=0;
                            NUMMIGF=0;
                            NUMMIGT=0;
                            NUMMIGT2=0;
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

     /* if MISSMIG > 0 then NUMMIG=.;    */  /*This line forces a stricter treatment of missing data */
     if b=1 then output work00_3;
     if a=1 and b=0 then output noricefile;

run;

proc contents data=work00_3 varnum;
run;

proc freq data=work00_3;
     title1 'Number of Migrants per HH';
     tables NUMMIGT NUMMIGM NUMMIGF;
     tables NUMMIGT*HELPDV2 / CHISQ;
     tables NUMMIGT2*HELPDV2 / CHISQ;
     /* tables TOTRRCD2*NUMRRCD2; */
     /* tables TOTRSND2*NUMRSND2; */
run;

proc corr data=work00_2;
     var TOTRRCD2 NUMRRCD2;
     var TOTRSND2 NUMRSND2;
     var TOTRRCD3 NUMRRCD3;
     var TOTRSND3 NUMRSND3;
run;

data out00_1.help0002;
     set work00_3;
run;

proc datasets;
     delete work00_1 work00_2 noricefile;
run;
