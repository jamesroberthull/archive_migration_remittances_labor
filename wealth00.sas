/*****************************************************************************
***     Programmer: Martin Piotrowski (amended by james r. hull)
***     Begin Date: 07/16/04
***     Purpose:
***             This program creates a hh wealth index using principle
***             components analysis and 2000 data
***
***
***
***     Input Data: /nangrong/data_sas/2000/current/hh00.04
***
***     Output Data: /trainee/jrhull/ma/wealth00.xpt
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


libname in1 xport '/nangrong/data_sas/2000/current/hh00.04';

libname out1 xport '/trainee/jrhull/ma/wealth00.xpt';

***************************
* Recode Household Assets *
***************************;

data recode(keep = VILL00 HHID00 GWINDOW CKFUEL CTV_GE17 CTV_LT17 VCR FRIDGE
                   ITAN BIKE MCYCLE_B MCYCLE_S CAR_TRUK SEWING_M tempid);
     set in1.hh00(keep = VILL00 HHID00 X6_4A1 X6_4A2 X6_4A3 X6_4A11 X6_4A12 X6_4A13
                         X6_4A14 X6_4A15 X6_4A16 X6_4A17 X6_4A18 X6_4A19 X6_4A20
                         WINDOW4 X6_1_1 - X6_1_5);

*** Glass Paned Windows ***;

    if WINDOW4 = 1 then GWINDOW = 1;
    else if WINDOW4 = 2 then GWINDOW = 0;
    else GWINDOW = .;

*** recode cooking fuel ***;

    *--------------------------------------------*
    |                                            |
    |  CKFUEL                                    |
    |         0 = Cooks with wood/charcoal/other |
    |         1 = Cooks with electricity or gas  |
    |                                            |
    *--------------------------------------------*;

    if (X6_1_4 = 1) or (X6_1_3 = 1) then CKFUEL = 1;
    else if (X6_1_1 = 1) or (X6_1_2 = 1) or (X6_1_5 = 1) then CKFUEL = 0;
    else CKFUEL = .;

*** recode number of color tv >= 17" ***;

    if X6_4A1 = 99 then CTV_GE17 = .;
    else CTV_GE17 = X6_4A1;

*** recode number of color tv < 17" ***;

    if X6_4A2 = 99 then CTV_LT17 = .;
    else CTV_LT17 = X6_4A2;

*** recode number of VCRs ***;

    if X6_4A3 = 99 then VCR = .;
    else VCR = X6_4A3;

*** recode refrigerator - combine one and two door refrigerators ***;

    if X6_4A11 in(.,99) or X6_4A12 in(.,99) then FRIDGE = .;
    else FRIDGE = X6_4A11 + X6_4A12;

*** recode number of Itans ***;

    if X6_4A13 = 99 then ITAN = .;
    else ITAN  = X6_4A13;

*** recode number of bicycles ***;

    if X6_4A14 = 99 then BIKE = .;
    else BIKE  = X6_4A14;

*** recode number of motorcycles 110+ cc ***;

    if X6_4A15 = 99 then MCYCLE_B = .;
    else MCYCLE_B  = X6_4A15;

*** recode number of motorcycles < 110 cc ***;

    if X6_4A16 = 99 then MCYCLE_S = .;
    else MCYCLE_S  = X6_4A16;

*** recode vehicle by combining the number of cars, trucks, and pick ups ***;

    if X6_4A17 in (99,.) or X6_4A18 in(99,.) or X6_4A19 in (99,.) then CAR_TRUK = .;
    else CAR_TRUK = X6_4A17 + X6_4A18 + X6_4A19;

*** recode number of sewing machines ***;

    if X6_4A20 = 99 then SEWING_M = .;
    else SEWING_M  = X6_4A20;

*** create tempid variable ***;

    tempid = 1;

run;

************************
* Delete missing cases *
************************;

data hh00b;
set recode;

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

proc means data=hh00b mean stddev;
var
    GWINDOW CKFUEL CTV_GE17 CTV_LT17 VCR FRIDGE
    ITAN BIKE MCYCLE_B MCYCLE_S CAR_TRUK SEWING_M;
run;

quit;

*********************************************
* Run Principal Components Analysis on Data *
*********************************************;

proc princomp data=hh00b outstat=eigenvt;
var
    GWINDOW CKFUEL CTV_GE17 CTV_LT17 VCR FRIDGE
    ITAN BIKE MCYCLE_B MCYCLE_S CAR_TRUK SEWING_M;

title 'PRINCIPAL COMPONENTS OUTPUT';
run;

data eigenvt2(keep= GWINDOW_PRIN1 CKFUEL_PRIN1 CTV_GE17_PRIN1 CTV_LT17_PRIN1 VCR_PRIN1
                    FRIDGE_PRIN1 ITAN_PRIN1 BIKE_PRIN1 MCYCLE_B_PRIN1 MCYCLE_S_PRIN1
                    CAR_TRUK_PRIN1 SEWING_M_PRIN1 tempid);
     set eigenvt;

     if _n_ = 17;

     drop _NAME_ _TYPE_;

     tempid = 1;

     GWINDOW_PRIN1 = GWINDOW;
     CKFUEL_PRIN1 = CKFUEL;
     CTV_GE17_PRIN1 = CTV_GE17;
     CTV_LT17_PRIN1 =CTV_LT17;
     VCR_PRIN1 = VCR;
     FRIDGE_PRIN1 = FRIDGE;
     ITAN_PRIN1 = ITAN;
     BIKE_PRIN1 = BIKE;
     MCYCLE_B_PRIN1 = MCYCLE_B;
     MCYCLE_S_PRIN1 = MCYCLE_S;
     CAR_TRUK_PRIN1 = CAR_TRUK;
     SEWING_M_PRIN1 = SEWING_M;

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
hh00b(in=a)
stats(in=b);
by tempid;

if a and b then output house;
if b and not a then output msmtch1;
if a and not b then output msmtch2;
run;

**************************
* Create HH Wealth Index *
**************************;

data hhasset; *(keep = hhid00 hhasset00 prcntile);
set house;

HHASSET00 =
        ((((GWINDOW - GWINDOW_mean)/GWINDOW_StdDev) * GWINDOW_PRIN1)
        + (((CKFUEL - CKFUEL_mean)/CKFUEL_StdDev) * CKFUEL_PRIN1)
        + (((CTV_GE17 - CTV_GE17_mean)/CTV_GE17_StdDev) * CTV_GE17_PRIN1)
        + (((CTV_LT17 - CTV_LT17_mean)/CTV_LT17_StdDev) * CTV_LT17_PRIN1)
        + (((VCR - VCR_mean)/VCR_StdDev) * VCR_PRIN1)
        + (((FRIDGE - FRIDGE_mean)/FRIDGE_StdDev) * FRIDGE_PRIN1)
        + (((BIKE - BIKE_mean)/BIKE_StdDev) * BIKE_PRIN1)
        + (((ITAN - ITAN_mean)/ITAN_StdDev) * ITAN_PRIN1)
        + (((CAR_TRUK - CAR_TRUK_mean)/CAR_TRUK_StdDev) * CAR_TRUK_PRIN1)
        + (((MCYCLE_B - MCYCLE_B_mean)/MCYCLE_B_StdDev) * MCYCLE_B_PRIN1)
        + (((MCYCLE_S - MCYCLE_S_mean)/MCYCLE_S_StdDev) * MCYCLE_S_PRIN1)
        + (((SEWING_M - SEWING_M_mean)/SEWING_M_StdDev) * SEWING_M_PRIN1));

prcntile = HHASSET00;

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
var HHID00 VILL00 LOWEST MIDDLE HIGHEST
    GWINDOW CKFUEL CTV_GE17 CTV_LT17 VCR
    FRIDGE ITAN BIKE MCYCLE_B MCYCLE_S
    CAR_TRUK SEWING_M;
run;

proc corr data=groups noprob nosimple;
var LOWEST MIDDLE HIGHEST
    GWINDOW CKFUEL CTV_GE17 CTV_LT17 VCR
    FRIDGE ITAN BIKE MCYCLE_B MCYCLE_S
    CAR_TRUK SEWING_M;
run;

proc freq data=groups;
tables LOWEST MIDDLE HIGHEST;
run;

*************************
* Output Data to Server *
*************************;

data out1.wealth00(keep= hhid00 LOWEST MIDDLE HIGHEST);
set groups;

run;
