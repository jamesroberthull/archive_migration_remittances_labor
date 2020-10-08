*****************************************************************************
***     Programmer: Jeff Edmeades, revised by Martin Piotrowski (and james r. hull)
***     Begin Date: 07/06/04
***     Purpose:
***             This program creates a wealth index of households using
***             principal components analysis.  It then then creates
***             dummy indicating whether a household is in the highest,
***             middle, or lowest portion of the income distribution
***
***     Input Data: /nangrong/data_sas/1994/current/hh94.03
***
***     Output Data: /trainee/jrhull/ma/wealth94.xpt
***
***
***
*******************************************************************************/

***********
* Options *
***********;

*** landscape ***;
/*options ls=175 ps=43;*/

*** portrait ***;
options ls=78 ps=58;

libname in1 xport '/nangrong/data_sas/1994/current/hh94.03';
libname out1 xport '/trainee/jrhull/ma/wealth94.xpt';

********************
* Bring in HH Data *
********************;

data hh94a(keep= VILL94 HHID94 CKFUEL BWTV CTV VCR FRIDGE ETAN CAR
                 MCYCLE SEWING WINDW ELECT94 tempid);
set in1.hh94(keep= VILL94 HHID94 Q6_3 Q6_44 Q6_1A Q6_2A Q6_2B Q6_2C
                   Q6_2D Q6_2E Q6_5A1 Q6_5B1 Q6_5C1 Q6_5D1 Q6_5E1
                   Q6_5F1 Q6_5G1 Q6_5H1 WINDOW Q6_44);

*** Delete HouseHolds that are duplicates ***;
/* if hhid94 ^in(20171412, 20171132, 20151112, 20150992, 20581052, 20081302); */

********************
* Recode Variables *
********************;

*** household debt ***;

if Q6_44=1 then HHDEBT=1;
else if Q6_44=2 then HHDEBT=0;
else HHDEBT = .;

*** cooking fuel ***;

*--------------------------------------------*
|                                            |
|  CKFUEL                                    |
|         1 = Cooks with wood/charcoal/other |
|         0 = Cooks with electricity or gas  |
|                                            |
*--------------------------------------------*;

if (Q6_2A=1 or Q6_2B=1 or Q6_2E=1) then CKFUEL=1;
else CKFUEL=0;

*** Black and White TV ***;

if (Q6_5A1 ne 9) then BWTV=Q6_5A1;
else if (Q6_5A1=9) then BWTV=.;

*** color TVs ***;

if (Q6_5B1 ne 9) then CTV=Q6_5B1;
else if (Q6_5B1=9) then CTV=.;

*** VCRs ***;

if (Q6_5C1 ne 9) then VCR=Q6_5C1;
else if (Q6_5C1 = 9) then VCR=.;

*** refrigerators ***;

if (Q6_5D1 ne 9) then FRIDGE=Q6_5D1;
else if Q6_5D1=9 then FRIDGE=.;

*** ETANs ***;

if (Q6_5E1 ne 9) then ETAN=Q6_5E1;
else if Q6_5E1=9 then ETAN=.;

*** CAR/TRUCK/PICKUP ***;

if (Q6_5F1 ne 9) then CAR=Q6_5F1;
else if Q6_5F1=9 then CAR=.;

*** Motorcyles ***;

if (Q6_5G1 ne 9) then MCYCLE=Q6_5G1;
else if Q6_5G1=9 then MCYCLE=.;

*** SEWING Machines ***;

if (Q6_5H1 ne 9) then SEWING=Q6_5H1;
else if Q6_5H1=9 then SEWING=.;

*** Windows ***;

*------------------------------------------------*
|                                                |
|  WINDW                                         |
|         1 = windows with glass panes/netting   |
|         0 = widows without glass panes/netting |
|                                                |
*------------------------------------------------*;

if (3<WINDOW<=7) then WINDW=1;
else if (1<=WINDOW<=3) then WINDW=0;
else if WINDOW=9 then WINDW=.;

*** Electricity ***;

if (Q6_1A=1) then ELECT94=1;
else if (Q6_1A=2) then ELECT94=0;
else if (Q6_1A=9) then ELECT94=.;

*** create tempid variable ***;

tempid = 1;

run;

************************
* Delete missing cases *
************************;

data hh94b;
set hh94a;

     array nvar(*) _numeric_;
     do i=1 to dim(nvar);
          if nvar(i)=. then delete;
     end;

drop i;

run;

*********************************************************
* Figure Out Means and Standard Deviations of Variables *
*********************************************************;

ods output Summary=mean_std;

proc means data=hh94b mean std;
var BWTV CTV VCR FRIDGE ETAN CAR MCYCLE SEWING
      CKFUEL WINDW ELECT94;
run;

quit;

*********************************************
* Run Principal Components Analysis on Data *
*********************************************;

proc princomp data=hh94b outstat=eigenvt;
var BWTV CTV VCR FRIDGE ETAN CAR MCYCLE SEWING
    CKFUEL WINDW ELECT94;
title1 'Principle Components output';
run;


data eigenvt2 (keep= BWTV_PRIN1 CTV_PRIN1 VCR_PRIN1 FRIDGE_PRIN1 ETAN_PRIN1 CAR_PRIN1
                    MCYCLE_PRIN1 SEWING_PRIN1 CKFUEL_PRIN1 WINDW_PRIN1
                    ELECT94_PRIN1 tempid);
     set eigenvt;

     if _n_ = 17;

     drop _NAME_ _TYPE_;

     tempid = 1;

     BWTV_PRIN1 = BWTV;
     CTV_PRIN1 = CTV;
     VCR_PRIN1 = VCR;
     FRIDGE_PRIN1 = FRIDGE;
     ETAN_PRIN1 = ETAN;
     CAR_PRIN1 = CAR;
     MCYCLE_PRIN1 = MCYCLE;
     SEWING_PRIN1 = SEWING;
     CKFUEL_PRIN1 = CKFUEL;
     WINDW_PRIN1 = WINDW;
     ELECT94_PRIN1 = ELECT94;

run;

****************************************
* Create id variable for mean_std data *
****************************************;

data meanstd2;
set mean_std;

tempid = 1;

run;

****************************************************************
* Merge Princomp Prin1 data with Mean_std data with hh94b data *
****************************************************************;

data stats msmtch msmtch0;
merge
eigenvt2(in=a)
meanstd2(in=b);
by tempid;

if a and b then output stats;
if b and not a then output msmtch;
if a and not b then output msmtch0;
run;


***************************************
* Merge Mean_std data with hh94b data *
***************************************;

data house msmtch1 msmtch2;
merge
hh94b(in=a)
stats(in=b);
by tempid;

if a and b then output house;
if b and not a then output msmtch1;
if a and not b then output msmtch2;
run;

**************************
* Create HH Wealth Index *
**************************;

data hhasset; *(keep = hhid94 hhasset94 prcntile);
set house;

HHASSET94=
        ((((BWTV - BWTV_mean)/BWTV_StdDev) * BWTV_PRIN1)
        + (((CTV - CTV_mean)/CTV_StdDev) * CTV_PRIN1)
        + (((VCR - VCR_mean)/VCR_StdDev) * VCR_PRIN1)
        + (((FRIDGE - FRIDGE_mean)/FRIDGE_StdDev) * FRIDGE_PRIN1)
        + (((ETAN - ETAN_mean)/ETAN_StdDev) * ETAN_PRIN1)
        + (((CAR - CAR_mean)/CAR_StdDev) * CAR_PRIN1)
        + (((MCYCLE - MCYCLE_mean)/MCYCLE_StdDev) * MCYCLE_PRIN1)
        + (((SEWING - SEWING_mean)/SEWING_StdDev) * SEWING_PRIN1)
        + (((CKFUEL - CKFUEL_mean)/CKFUEL_StdDev) * CKFUEL_PRIN1)
        + (((WINDW - WINDW_mean)/WINDW_StdDev) * WINDW_PRIN1));


prcntile = HHASSET94;

run;

/*
proc freq data=hhasset;
tables prcntile;
run;
*/

********************************************
* Create percentile variable for HHASSET94 *
********************************************;

proc rank data=hhasset groups=100 out=prcntile;
var prcntile;
run;

*********************************************
* Group Wealth Data According to Percentile *
*********************************************;

data groups;
set prcntile;

*** Lowest - Bottom 33% of HH ***;

if (prcntile le 33) then LOWEST = 1;
else LOWEST=0;

*** Middle - 34th-79th percentiles ***;

if (33 lt prcntile le 79) then MIDDLE=1;
else MIDDLE=0;

*** Highest - Top 20% or 80th percentile or above ***;

if (prcntile gt 79) then HIGHEST = 1;
else HIGHEST=0;

run;

proc print data=groups (obs=100);
var HHID94 PRCNTILE HHASSET94 CKFUEL BWTV CTV VCR FRIDGE
    ETAN CAR MCYCLE SEWING WINDW ELECT94 LOWEST MIDDLE HIGHEST;
run;

proc corr data=groups noprob nosimple;
     var LOWEST MIDDLE HIGHEST CKFUEL BWTV CTV VCR FRIDGE ETAN CAR MCYCLE SEWING WINDW ELECT94;
run;

proc freq data=groups;
tables LOWEST MIDDLE HIGHEST;
run;

*************************
* Output Data to Server *
*************************;

data out1.wealth94(keep= hhid94 LOWEST MIDDLE HIGHEST);
set groups;

run;
