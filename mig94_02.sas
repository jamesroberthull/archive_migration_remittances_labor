*********************************************************************
**     Program Name: /home/jrhull/ma/mig94_02.sas
**     Programmer: james r. hull
**     Start Date: 2005 July 06
**     Purpose:
**        1.) Create control variables for 1994 data
**        2.) Save datasets for further analysis
**     Input Data:
**        1.) '/nangrong/data_sas/1994/current/hh94.03'
**        2.) '/nangrong/data_sas/1994/current/indiv94.03'
**        3.) '/nangrong/data_sas/1994/current/comm94.01'
**        4.) '/trainee/jrhull/ma/help9402.xpt'
**        5.) '/trainee/jrhull/ma/wealth94.xpt'
**     Output Data:
**        1.) '/trainee/jrhull/ma/help9403.xpt'
**        2.) '/trainee/jrhull/ma/merge94.xpt'
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 'Creating Control Variables: 1994 migration data';

*------------------*
*  Data Libraries  *
*------------------*;

libname in94_1 xport '/nangrong/data_sas/1994/current/hh94.03';
libname in94_2 xport '/nangrong/data_sas/1994/current/indiv94.03';
libname in94_3 xport '/nangrong/data_sas/1994/current/comm94.01';
libname in94_4 xport '/trainee/jrhull/ma/help9402.xpt';
libname in94_5 xport '/trainee/jrhull/ma/wealth94.xpt';

libname out94_1 xport '/trainee/jrhull/ma/help9403.xpt';
libname out94_2 xport '/trainee/jrhull/ma/merge94.xpt';

*-----------------------------------------------*
*    Assemble all necessary control variables   *
*-----------------------------------------------*;


data work94_1 (keep=VILL94 LEKTI94 HHID94 CEP94 Q1 AGE Q3 Q27 Q31);
     set in94_2.indiv94 (keep=VILL94 LEKTI94 HHID94 CEP94 Q1 Q2 Q3 CODE2 Q27 Q31);

     *** Recode specially coded ages to numeric equivalents ***;

     if Q2 in (81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91) then AGE=0;
        else if Q2=98 then AGE=0;
        else if Q2=99 then AGE=0;
        else AGE=Q2;

    *** Remove duplicate code 2 cases - leave destination HH data ***;

    if CODE2 ^in (1,5);

run;

data work94_2 (keep=VILL94 HHID94 AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL NUMDEPS M_13_65
                    F_13_65 NUMREMIT NUMREMSD REMITND SREMITND);
     set work94_1;
     by HHID94;

     keep VILL94 HHID94 AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL NUMDEPS M_13_65 F_13_65
          NUMREMIT NUMREMSD REMITND SREMITND;

     *** Create variables: # of HH members, # males, # females, mean age, # remitters ***;

     retain AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL NUMDEPS M_13_65 F_13_65
            NUMREMIT NUMREMSD REMITND SREMITND;

     if first.HHID94 then do;
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

     if Q1 ^in (0,2,3,9) then do;

                       if ((13 <= AGE <=65) and (Q3=1))
                          then M_13_65=M_13_65+1; /*Males 13-65*/

                       if ((13 <= AGE <=65) and (Q3=2))
                          then F_13_65=F_13_65+1; /*Females 13-65*/

                       if (AGE < 13) then NUMDEPCH=NUMDEPCH+1;
                       if (AGE > 65) then NUMDEPEL=NUMDEPEL+1;

                       NUMDEPS=NUMDEPCH+NUMDEPEL;

                       AGETOTAL=AGETOTAL+AGE;

                       NUMMEMS=NUMMEMS+1;

                       if Q3=1 then NUMMALES=NUMMALES+1;
                          else if Q3=2 then NUMFEMS=NUMFEMS+1;

                       if Q27=1 then NUMREMIT=NUMREMIT+1;
                          else if Q27=9 then REMITND=1;

                       if Q31=1 then NUMREMSD=NUMREMSD+1;
                          else if Q31=9 then SREMITND=1;

                     end;

     if last.HHID94 then output;

run;

data work94_3 (keep=VILL94 VILL_WAM VILL_WAF);
     set work94_1;
     by VILL94;

     keep VILL94 VILL_WAM VILL_WAF;

     retain VILL_WAM VILL_WAF;

     if first.VILL94 then do;
                            VILL_WAM=0;
                            VILL_WAF=0;
                          end;


     if ((13 <= AGE <=65) and (Q3=1)) then VILL_WAM=VILL_WAM+1; /*Males 13-65*/

     if ((13 <= AGE <=65) and (Q3=2)) then VILL_WAF=VILL_WAF+1; /*Females 13-65*/

     if last.VILL94 then output;

run;


*** Create # rai planted in rice by each VILLAGE ***;

data work94_4 (keep=VILL94 VILL_RAI);
     set in94_1.hh94 (keep=VILL94 Q6_17);   /* Q6_17 is measured in square wa, more or less */
     by VILL94;

     keep VILL94 VILL_RAI;

     retain VILL_RAI;

     if first.VILL94 then do;
                            VILL_RAI=0;
                          end;

     if Q6_17 < 100 then VILL_RAI=VILL_RAI+0;                 /* These functions also convert from square wa to rai */
         else if Q6_17=99999 then VILL_RAI=VILL_RAI+0;
         else if Q6_17 ^in (99995, 99998, .) then VILL_RAI=VILL_RAI+(Q6_17*0.0025);
         else if Q6_17=99995 then VILL_RAI=VILL_RAI+250;

     if last.VILL94 then output;

run;

data work94_5 (drop=Q6_4SA Q6_4WA Q6_4OA Q6_4CA Q6_10A Q6_10B Q6_10C Q6_26 Q6_22);
     merge in94_1.hh94 (keep=vill94 hhid94 Q6_4SA Q6_4WA Q6_4OA Q6_4CA
                             Q6_10A Q6_10B Q6_10C Q6_17 Q6_22 Q6_26 in=a)
           work94_2 (in=b);
     by HHID94;

     MEANAGE=AGETOTAL/NUMMEMS;
     /*if REMITND=1 then NUMREMIT=.; */ /* These statements force a stricter treatment of missing data */
     /*if SREMITND=1 then NUMREMSD=.; */

     if Q6_4SA=0 then SILK=0;
        else SILK=1;

     if Q6_4WA=0 then SILKWORM=0;
        else SILKWORM=1;

     if Q6_4OA=0 then CLOTH=0;
        else CLOTH=1;

     if Q6_4CA=0 then CHARCOAL=0;
        else CHARCOAL=1;

     if Q6_10A=0 then COWS=0;
        else if Q6_10A=9999 then COWS=.;
        else if Q6_10A>=3000 then COWS=Q6_10A-3000;
        else if Q6_10A>=2000 then COWS=Q6_10A-2000;
        else if Q6_10A>=1000 then COWS=Q6_10A-1000;

     if Q6_10B=0 then BUFFALO=0;
        else if Q6_10B=9999 then BUFFALO=.;
        else if Q6_10B>=3000 then BUFFALO=Q6_10B-3000;
        else if Q6_10B>=2000 then BUFFALO=Q6_10B-2000;
        else if Q6_10B>=1000 then BUFFALO=Q6_10B-1000;

     if Q6_10C=0 then PIGS=0;
        else if Q6_10C=999 then PIGS=.;
        else if Q6_10C>=3000 then PIGS=Q6_10C-3000;
        else if Q6_10C>=2000 then PIGS=Q6_10C-2000;
        else if Q6_10C>=1000 then PIGS=Q6_10C-1000;

     if Q6_26=2 then CASSAVA=0;
        else if Q6_26=1 then CASSAVA=1;
        else CASSAVA=.;

     if Q6_22=9998 then RICE_YLD=0;
        else if Q6_22=9999 then RICE_YLD=.;
        else RICE_YLD=Q6_22;

     if SILK=1 or SILKWORM=1 or CLOTH=1 then COTTAGE=1;
        else COTTAGE=0;

run;

data work94_6 nosurvey;
     merge work94_5 (in=a)
           work94_3 (in=b)
           work94_4 (in=c)
           in94_3.comm94 (in=d keep=VILL94 Q5_76_1 BSY76_1 NBSY76_1 Q5_76_2 BSY76_2 NBSY76_2);

     by VILL94;

     if a=1 and b=1 and c=1 and d=1 then output work94_6;
     if a=0 and b=0 and c=0 and d=1 then output nosurvey;

run;

data work94_7 nodepvar nocontrols;              /* Merges control var's to this point with mig var's */
     merge work94_6 (in=a)
           in94_4.help9402 (in=b);
     if a=1 and b=1 then output work94_7;
     if a=1 and b=0 then output nodepvar;
     if a=0 and b=1 then output nocontrols;
run;


data work94_8 (drop=Q6_17 BSY76_: NBSY76_: CCAT23F CCATALLA CCATVF CCATOF);
     set work94_7 (drop= HELP23C: HELP23D: HELP23F: HELP23G: HELPOC: HELPOD:
                         HELPOE: HELPOF: HELPOG: HELPVC: HELPVD: HELPVE:
                         HELPVF: HELPVG: HELPXC: HELPXD: HELPXE: HELPXF:
                         HELPXG:);

     if HELP23B=. then HELP23B=0;
     if HELPVB=. then HELPVB=0;
     if HELPOB=. then HELPOB=0;

     TOTHELP=HELP23B+HELPVB+HELPOB;

     VILL1365=VILL_WAM+VILL_WAF;  /*Sums working age males and females in village (collinearity problems) */

     if Q6_17=99995 then HH_RAI=(100000/400);
        else if Q6_17=99999 then HH_RAI=.;
        else if Q6_17=99998 then HH_RAI=0;
        else if Q6_17<100 then HH_RAI=.;
                else HH_RAI=Q6_17/400;

     if BSY76_1=998 then V_WAGEMH=.;
        else V_WAGEMH=BSY76_1;
     if NBSY76_1=998 then V_WAGEML=.;
        else V_WAGEML=NBSY76_1;
     if BSY76_2=998 then V_WAGEFH=.;
        else V_WAGEFH=BSY76_2;
     if NBSY76_2=998 then V_WAGEFL=.;
        else V_WAGEFL=NBSY76_2;

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
     label CASSAVA= '94: plant cassava in past year (Q6.26)';
     label RICE_YLD= '94: amount of rice yield - tangs (Q6.22)';
     label V_WAGEMH= '94: rice labor high demand - men (Q76)';
     label V_WAGEFH= '94: rice labor low demand - men (Q76)';
     label V_WAGEML= '94: rice labor high demand - women (Q76)';
     label V_WAGEFL= '94: rice labor low demand - women (Q76)';
     label VILL1365= '# working age adults in village';
     label TOTHELP= 'Total # helpers all sources';
     label NUMMIGT2= '# HH mig (b/f harvest) 3-yr window';
     label RECMIG2= '# HH mig (after harvest) 3-yr window';
     label MISSMIG2= '# HH mig (left unknown) 3-yr window';
     label NUMRRCD3= '# HH remit (b/f harvest) 3-yr win';
     label NURRSND3= '# HH receive (b/f harvest) 3-yr win';

     rename Q5_76_1=V_HELPM Q5_76_2=V_HELPF;

run;

proc datasets;
     delete work94_1 work94_2 work94_3 work94_4 work94_5 work94_6 work94_7;
run;

 *** Add in wealth index variables ***;

data work94_9 wealthonly;
     merge work94_8 (in=a)
           in94_5.wealth94 (in=b);
     by hhid94;

     if a=1 then output work94_9;
     if a=1 and b=0 then do;
                            LOWEST=.;
                            MIDDLE=.;
                            HIGHEST=.;
                         end;

     if a=0 and b=1 then output wealthonly;
run;

data work94_0;
     set work94_9;

     label LOWEST= 'HH is in lowest HH Assets PCA grouping';
     label MIDDLE= 'HH is in middle HH Assets PCA grouping';
     label HIGHEST= 'HH is in highest HH Assets PCA grouping';

run;

*** Add in count of code 2 migrants ***;

data work94_1;
     set in94_2.indiv94 (keep=HHID94 Q1);

     by HHID94;

     keep HHID94 CODETWO;

     retain CODETWO;

     if first.HHID94 then do;
                            CODETWO=0;
                          end;

     if Q1=2 then CODETWO=CODETWO+1;

     if last.HHID94 then output;
run;

data work94_2;
     merge work94_1 (in=a)
           work94_0 (in=b);
     by HHID94;

     label CODETWO= '# Former HH members living in village';

     if a=1 and b=1 then output;
run;

proc contents data=work94_2;
run;

data out94_1.help9403;
     set work94_2;
     if HHTYPE94 in (1,3);      *** Remove NEW HH's from final file ***;
run;

*** Create a file to use in match-merging the 1994 and 2000 data ***;

data out94_2.merge94;
     set work94_2 (keep=VILL94 HHID94 HELPDV HELPDV2 NUMMIGT NUMRRCD2 NUMRSND2 HHTYPE94 CODETWO
                        M_13_65 F_13_65 NUMDEPS MEANAGE CASSAVA COTTAGE PIGS COWS
                        CHARCOAL LOWEST MIDDLE HIGHEST VILL1365 VILL_RAI);
 rename HELPDV=HELPD194 HELPDV2=HELPD294 NUMMIGT=NUMMIG94 NUMRRCD2=NUMRCD94 NUMRSND2=NUMSND94
        CODETWO=CODE2_94 M_13_65=M1365_94 F_13_65=F1365_94 NUMDEPS=NUMDEP94 MEANAGE=MNAGE_94
        CASSAVA=CASS_94 COTTAGE=COTT_94 PIGS=PIGS_94 COWS=COWS94 CHARCOAL=CHAR_94
         LOWEST=LOW_94 MIDDLE=MID_94 HIGHEST=HIGH_94 VILL1365=V1365_94 VILL_RAI=VRAI_94;

run;
