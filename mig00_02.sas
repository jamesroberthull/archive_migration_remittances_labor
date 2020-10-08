*********************************************************************
**     Program Name: /home/jrhull/ma/mig00_02.sas
**     Programmer: james r. hull
**     Start Date: 2005 July 12
**     Purpose:
**        1.) Create control variables for analysis
**        2.)
**     Input Data:
**        1.) '/nangrong/data_sas/2000/current/hh00.04'
**        2.) '/nangrong/data_sas/2000/current/indiv00.03'
**        3.) '/nangrong/data_sas/2000/current/comm00.02'
**        4.) '/trainee/jrhull/ma/help0002.xpt'
**        5.) '/nangrong/data_sas/2000/current/plots00.02'
**        6.) '/trainee/jrhull/ma/wealth00.xpt'
**     Output Data:
**        1.) '/trainee/jrhull/ma/help0003.xpt'
**        2.) '/trainee/jrhull/ma/merge00.xpt'
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

libname in00_1 xport '/nangrong/data_sas/2000/current/hh00.04';       /* Sorted by HHID00 */
libname in00_2 xport '/nangrong/data_sas/2000/current/indiv00.03';    /* S.B. HHID00 CEP00 */
libname in00_3 xport '/nangrong/data_sas/2000/current/comm00.02';     /* S.B. VILL00 */
libname in00_4 xport '/trainee/jrhull/ma/help0002.xpt';               /* S.B. HHID00 */
libname in00_5 xport '/nangrong/data_sas/2000/current/plots00.02';    /* S.B. HHID00 PLANG00 */
libname in00_6 xport '/trainee/jrhull/ma/wealth00.xpt';

libname out00_1 xport '/trainee/jrhull/ma/help0003.xpt';              /* S.B. HHID00 */
libname out00_2 xport '/trainee/jrhull/ma/merge00.xpt';

*--------------------------------------------*
*  Assemble all necessary control variables  *
*--------------------------------------------*;


data work00_1 (keep=HHID00 CEP00 X1 AGE X4 X25 X28);
     set in00_2.indiv00 (keep=HHID00 CEP00 X1 X3 X4 X25 X28 CODE2);

     *** Recode specially coded ages to numeric equivalents ***;

        if X3=99 then AGE=0;
           else if X3=. then AGE=0; *** Code 1 missing case to 0 for composite measures ***;
           else AGE=X3;

    *** Remove duplicate code 2 cases - leave destination HH data ***;

    if CODE2 ^in (1);

run;

*** HH-level variable creation ***;

data work00_2 (keep=HHID00 AGETOTAL NUMMEMS NUMMALES NUMFEMS
                    NUMDEPCH NUMDEPEL NUMDEPS M_13_65
                    F_13_65 NUMREMIT NUMREMSD REMITND SREMITND);                /* S.B. HHID00 */
     set work00_1;
     by HHID00;

     keep HHID00 AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH
          NUMDEPEL NUMDEPS M_13_65 F_13_65 NUMREMIT NUMREMSD
          REMITND SREMITND;

     retain AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL
            NUMDEPS M_13_65 F_13_65 NUMREMIT NUMREMSD REMITND SREMITND;

     if first.HHID00 then do;
                            AGETOTAL=0;
                            NUMMEMS=0;
                            NUMMALES=0;
                            NUMFEMS=0;
                            NUMDEPCH=0;
                            NUMDEPEL=0;
                            NUMDEPS=0;
                            M_13_65=0;
                            F_13_65=0;
                            NUMREMIT=0;
                            NUMREMSD=0;
                            REMITND=0;
                            SREMITND=0;
                          end;

     if X1 ^in (0,2,3,9) then do;

                            if ((13 <= AGE <=65) and (X4=1))
                               then M_13_65=M_13_65+1; /*Males 13-65*/
                            if ((13 <= AGE <=65) and (X4=2))
                               then F_13_65=F_13_65+1; /*Females 13-65*/

                            if (AGE < 13) then NUMDEPCH=NUMDEPCH+1;
                            if (AGE > 65) then NUMDEPEL=NUMDEPEL+1;

                            NUMDEPS=NUMDEPCH+NUMDEPEL;

                            AGETOTAL=AGETOTAL+AGE;

                            NUMMEMS=NUMMEMS+1;

                            if X4=1 then NUMMALES=NUMMALES+1;
                               else if X4=2 then NUMFEMS=NUMFEMS+1;

                            if X25=1 then NUMREMIT=NUMREMIT+1;
                               else if X25=9 then REMITND=1;

                            if X28=1 then NUMREMSD=NUMREMSD+1;
                               else if X28=9 then SREMITND=1;

                         end;

     if last.HHID00 then output;

run;


*** add variables VILL00 and VILL94 to collapsed individual-level data ***;

data work00_1b noidvars nodata;                             /* S.B. HHID00 */
     merge work00_1 (in=a)
           in00_1.hh00 (keep= HHID00 VILL00 VILL94 in=b);
     by HHID00;
     if a=1 and b=1 then output work00_1b;
     if a=1 and b=0 then output noidvars;
     if a=0 and b=1 then output nodata;
run;

*** Sort by VILL94 before collapsing data by village ***;

proc sort data=work00_1b out=work00_1c;                     /* S.B. VILL94 */
     by VILL94;
run;

*** village-level variable creation ***;

data work00_3 (keep=VILL94 VILL_WAM VILL_WAF);             /* S.B. VILL94 */
     set work00_1c;
     by VILL94;

     keep VILL94 VILL_WAM VILL_WAF;

     retain VILL_WAM VILL_WAF;

     if first.VILL94 then do;
                            VILL_WAM=0;
                            VILL_WAF=0;
                          end;


     if ((13 <= AGE <=65) and (X4=1)) then VILL_WAM=VILL_WAM+1; /*Males 13-65*/

     if ((13 <= AGE <=65) and (X4=2)) then VILL_WAF=VILL_WAF+1; /*Females 13-65*/

     if last.VILL94 then output;

run;

data work00_4a;                                           /* S.B. HHID00 */
     set in00_5.plots00 (keep=HHID00 PLANG00 X6_20_1 X6_14NGA X6_14RAI X6_14WA X6_15NGA X6_15RAI X6_15WA);

     by HHID00;

     keep HHID00 HH_RAI;

     retain HH_RAI;

     if first.HHID00 then do;
                            HH_RAI=0;
                          end;

     if X6_20_1=1 then do;
                          if X6_14RAI ^in (9999,0,.) then HH_RAI=HH_RAI+X6_14RAI;
                             else if X6_14NGA ^in (99,0,.) then HH_RAI=HH_RAI+(0.25*X6_14NGA);
                             else if X6_14WA ^in (9999,0,.) then HH_RAI=HH_RAI+(0.0025*X6_14WA);
                             else if X6_15RAI ^in (9999,.,0) then HH_RAI=HH_RAI+X6_15RAI;
                             else if X6_15NGA ^in (9999,.,0) then HH_RAI=HH_RAI+(0.25*X6_15NGA);
                             else if X6_15WA ^in (9999,.,0) then HH_RAI=HH_RAI+(0.0025*X6_15WA);
                       end;

     if last.HHID00 then output;

run;

data work00_4b notinhh00;                               /* S.B. HHID00 */
     merge work00_4a (in=a)
           in00_1.hh00 (in=b keep=HHID00 VILL00 VILL94);
     by HHID00;
     if b=1 then output work00_4b;
     if a=1 and b=0 then output notinhh00;
run;

data work00_4c;                                        /* S.B. HHID00 */
     set work00_4b;

     if HH_RAI=. then HH_RAI=0;  /* Treat missing as 0 for village calc's */
run;

*** sort HH-level data by VILL94 before collapsing to village-level ***;

proc sort data=work00_4c out=work00_4d;                /* S.B. VILL94 */
     by VILL94;
run;

data work00_4e;                                        /* S.B. VILL94 */
     set work00_4d;

     by VILL94;

     keep VILL94 VILL_RAI;

     retain VILL_RAI;

     if first.VILL94 then do;
                            VILL_RAI=0;
                          end;

     if HH_RAI ne 999999 then VILL_RAI=VILL_RAI+HH_RAI;
        else VILL_RAI=VILL_RAI;

     if last.VILL94 then output;


run;

*** merge village-level variables ***;

data work00_4f novillrai nohhidvars novilldems;        /* S.B. VILL94 - ALL */
     merge work00_4e (in=a)
           work00_4d (in=b)
           work00_3 (in=c);
     by VILL94;
     if a=1 and b=1 and c=1 then output work00_4f;
     if a=0 then output novillrai;
     if b=0 then output nohhidvars;
     if c=0 then output novilldems;
run;

proc sort data=work00_4f out=work00_4g;                /* S.B. HHID00 */
     by HHID00;
run;

*** Get other HH-level variables needed ***;

data work00_5 (drop=X6_10A: X6_10B: X6_3A:);                                         /* S.B. HHID00 */
     merge in00_1.hh00 (keep=VILL00 HHID00 X6_3A1 X6_3A2
                             X6_3A3 X6_3A4 X6_10A1 X6_10A2 X6_10A3 X6_10B1
                             X6_10B2 X6_10B3 X6_87A1 X6_87A2 X6_87A3
                             CASSAVA HHTYPE00 in=a)
           work00_2 (in=b);
     by HHID00;

     if NUMMEMS ne 0 then do;
                           MEANAGE=AGETOTAL/NUMMEMS;
                          end;
     else MEANAGE=.;

     /*if REMITND=1 then NUMREMIT=.; */ /* These statements force a stricter treatment of missing data */
     /*if SREMITND=1 then NUMREMSD=.; */

     if X6_3A1=0 then SILK=0;
        else if X6_3A1=9 then SILK=.;
        else SILK=1;

     if X6_3A2=0 then SILKWORM=0;
       else if X6_3A2=9 then SILKWORM=.;
       else SILKWORM=1;

     if X6_3A3=0 then CLOTH=0;
       else if X6_3A3=9 then CLOTH=.;
       else CLOTH=1;

     if X6_3A4=0 then CHARCOAL=0;
       else if X6_3A3=9 then CHARCOAL=.;
       else CHARCOAL=1;

     if X6_10A1 in (1,2) then COWS=X6_10B1;
        else if X6_10A1=9 then COWS=.;
        else if X6_10A1=3 then COWS=0;

     if X6_10A2 in (1,2) then BUFFALO=X6_10B2;
        else if X6_10A2=9 then BUFFALO=.;
        else if X6_10A2=3 then BUFFALO=0;

     if X6_10A3 in (1,2) then PIGS=X6_10B3;
        else if X6_10A3=9 then PIGS=.;
        else if X6_10A3=3 then PIGS=0;

     if CASSAVA in (.,2) then CASSAVA=0;
        else if CASSAVA=9 then CASSAVA=1;

     if SILK=1 or SILKWORM=1 or CLOTH=1 then COTTAGE=1;
        else COTTAGE=0;

run;

*** merge HH-level variables ***;

data work00_6a nohhlevelvars nohhrai novillevelvars;                    /* S.B. HHID00 */
     merge work00_5 (in=a)
           work00_4c (in=b)
           work00_4g (in=c);
     by HHID00;
     if a=1 and b=1 then output work00_6a;
     if a=0 then output nohhlevelvars;
     if b=0 then output nohhrai;
     if c=0 then output novillevelvars;
run;


*** merge village-level variables onto HH-level variables ***;

data work00_6b nosurvey;
     merge work00_6a (in=a)
           in00_3.comm00 (in=b keep=VILL00 X45MALE X45FEM X45MHIGH X45FHIGH
                                    X45MTYP X45FTYP);

     by VILL00;

     if a=1 and b=1 then output work00_6b;
     if a=0 and b=1 then output nosurvey;
run;


data work00_7 nodepvar nocontrols;
     merge work00_6b (in=a)
           in00_4.help0002 (in=b);
     if a=1 and b=1 then output work00_7;
     if a=1 and b=0 then output nodepvar;
     if a=0 and b=1 then output nocontrols;

run;


data work00_8 (drop=X6_87A: X45MALE X45FEM CCAT23F CCATALLA CCATOF CCATVF);
     set work00_7 (drop= HELP23C: HELP23F: HELPOC: HELPOE: HELPOF: HELPVC: HELPVE:
                         HELPVF:);

     if X6_87A1=999 then RICE_JAS=999;
        else if X6_87A1=. then RICE_JAS=0;
        else RICE_JAS=X6_87A1*(100/15);          /* This converts from grasops to tang */

     if X6_87A2=999 then RICE_STK=999;
        else if X6_87A2=. then RICE_STK=0;
        else RICE_STK=X6_87A2*(100/15);          /* This converts from grasops to tang */

     if X6_87A3=999 then RICE_OTH=999;
        else if X6_87A3=. then RICE_OTH=0;
        else RICE_OTH=X6_87A3*(100/15);          /* This converts from grasops to tang */

     if RICE_JAS=999 & RICE_STK=999 & RICE_OTH=999 then RICE_YLD=.;
        else if RICE_JAS=999 & RICE_STK ne 999 & RICE_OTH ne 999 then RICE_YLD=RICE_STK+RICE_OTH;
        else if RICE_JAS=999 & RICE_STK=999 & RICE_OTH ne 999 then RICE_YLD=RICE_OTH;
        else if RICE_JAS=999 & RICE_STK ne 999 & RICE_OTH=999 then RICE_YLD=RICE_STK;
        else if RICE_JAS ne 999 & RICE_STK=999 & RICE_OTH ne 999 then RICE_YLD=RICE_JAS+RICE_OTH;
        else if RICE_JAS ne 999 & RICE_STK ne 999 & RICE_OTH=999 then RICE_YLD=RICE_JAS+RICE_STK;
        else if RICE_JAS ne 999 & RICE_STK=999 & RICE_OTH=999 then RICE_YLD=RICE_JAS;
             else RICE_YLD=RICE_JAS+RICE_STK+RICE_OTH;


     if NUMMEMS=0 then NUMMEMS=.;    /* There are two HHS who had no living members in 00 */

     if HELPHH=. then HELPHH=0;
     if HELP23B=. then HELP23B=0;
     if HELPVB=. then HELPVB=0;
     if HELPOB=. then HELPOB=0;

     TOTHELP=HELP23B+HELPVB+HELPOB;
     TOTHELP2=HELPHH+HELP23B+HELPVB+HELPOB;

     VILL1365=VILL_WAM+VILL_WAF;  /*Sums working age males and females in village (collinearity problems) */

     if X45MALE=. then V_HELPM=0;
        else V_HELPM=X45MALE;
     if X45FEM=. then V_HELPF=0;
        else V_HELPF=X45FEM;

     label AGETOTAL='sum ages of HH members';
     label BUFFALO= '# buffalo raised by HH';
     label CHARCOAL= 'HH makes charcoal: 0-no 1-yes';
     label CLOTH= 'HH makes cloth: 0-no 1-yes';
     label COWS= '# cows raised by HH';
     label COTTAGE= 'HH engages in a cottage industry';
     label F_13_65= '# working age females in HH';
     label HELPDV= 'HH rice harvest strategy measure 1';
     label HELPDV2= 'HH rice harvest strategy measure 2';
     label HH_RAI= '# rai rice paddy used by HH last year';
     label MEANAGE= 'Mean age of HH members';
     label MISSMIG= '# HH migrants of unknown duration';
     label M_13_65= '# working age males in HH';
     label NUMFEMS= '# females in HH';
     label NUMMALES= '# males in HH';
     label NUMMEMS= '# HH members';
     label NUMMIGT= '# HH migrants (left b/f last harvest)';
     label NUMMIGM= '# male HH migrants (b/f last harvest)';
     label NUMMIGF= '# female HH migrants (b/f last harvest)';
     label NUMREMIT= '# HH members remitting money';
     label NUMREMSD= '# HH members receiving money';
     label NUMRRCD2= '# HH mig (left b/f harvest) remit';
     label NUMRSND2= '# HH mig (left b/f harvest) receive';
     label NUMDEPCH= '# HH members under age 13';
     label NUMDEPEL= '# HH members over age 65';
     label NUMDEPS= '#HH members under 13 & over 65';
     label PIGS= '# pigs raised by HH';
     label RECMIG= '# HH migrants (left after last harvest)';
     label SILK= 'HH makes silk: 0-no 1-yes';
     label SILKWORM= 'HH raises silkworm 0-no 1-yes';
     label VILL_RAI= '# rai rice paddy village last yr';
     label VILL_WAF= '# working age females in village';
     label VILL_WAM= '# working age males in village';
     label RICE_YLD= '00: amount of rice yield - tangs (Q87)';
     label V_HELPM= '00: males hired for labor (Q45)';
     label V_HELPF= '00: females hired for labor (Q45)';
     label VILL1365= '# working age adults in village';
     label TOTHELP= 'Total # helpers all sources';
     label TOTHELP2= 'Total # helpers all sources (plus HH)';
     label NUMMIGT2= '# HH mig (b/f harvest) 3-yr window';
     label RECMIG2= '# HH mig (after harvest) 3-yr window';
     label MISSMIG2= '# HH mig (left unknown) 3-yr window';
     label NUMRRCD3= '# HH remit (b/f harvest) 3-yr win';
     label NURRSND3= '# HH receive (b/f harvest) 3-yr win';

     rename X45FHIGH=V_WAGEFH X45MHIGH=V_WAGEMH X45FTYP=V_WAGEFT X45MTYP=V_WAGEMT;

run;

proc datasets;
     delete work00_1: work00_2 work00_3 work00_4: work00_5 work00_6: work00_7
            nodata noidvars novillrai nohhidvars novilldems nodepvar nocontrols
            nosurvey nohhrai nohhlevelvars novillevelvars notinhh00;
run;

 *** Add in wealth index variables ***;

data work00_9 wealthonly;
     merge work00_8 (in=a)
           in00_6.wealth00 (in=b);
     by hhid00;

     if a=1 then output work00_9;
     if a=1 and b=0 then do;
                            LOWEST=.;
                            MIDDLE=.;
                            HIGHEST=.;
                         end;

     if a=0 and b=1 then output wealthonly;
run;

data work00_0;
     set work00_9;

     label LOWEST= 'HH is in lowest HH Assets PCA grouping';
     label MIDDLE= 'HH is in middle HH Assets PCA grouping';
     label HIGHEST= 'HH is in highest HH Assets PCA grouping';
run;

*** Add in count of code 2 migrants per household ***;

data work00_1;
     set in00_2.indiv00 (keep=HHID00 X1);

     by HHID00;

     keep HHID00 CODETWO;

     retain CODETWO;

     if first.HHID00 then do;
                            CODETWO=0;
                          end;

     if X1=2 then CODETWO=CODETWO+1;

     if last.HHID00 then output;
run;

data work00_2;
     merge work00_1 (in=a)
           work00_0 (in=b);
     by HHID00;

     label CODETWO= '# Former HH members living in village';

     if a=1 and b=1 then output;
run;

proc contents data=work00_2;
run;

data out00_1.help0003;
     set work00_2;
     if HHTYPE00 in (1,3);   *** Remove NEW HH's from final file ***;
run;

*** Create a file to use in match-merging the 1994 and 2000 data ***;

data out00_2.merge00;
     set work00_2 (keep=VILL94 HHID94 VILL00 HHID00 HELPDV HELPDV2 NUMMIGT NUMRRCD2 NUMRSND2 HHTYPE00 CODETWO
                        M_13_65 F_13_65 NUMDEPS MEANAGE CASSAVA COTTAGE PIGS COWS
                        CHARCOAL LOWEST MIDDLE HIGHEST VILL1365 VILL_RAI);
    rename HELPDV=HELPD100 HELPDV2=HELPD200 NUMMIGT=NUMMIG00 NUMRRCD2=NUMRCD00 NUMRSND2=NUMSND00
           CODETWO=CODE2_00 M_13_65=M1365_00  F_13_65=F1365_00 NUMDEPS=NUMDEP00 MEANAGE=MNAGE_00
           CASSAVA=CASS_00 COTTAGE=COTT_00 PIGS=PIGS_00 COWS=COWS00 CHARCOAL=CHAR_00
           LOWEST=LOW_00 MIDDLE=MID_00 HIGHEST=HIGH_00 VILL1365=V1365_00 VILL_RAI=VRAI_00;

run;
