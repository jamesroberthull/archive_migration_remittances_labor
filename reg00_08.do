/* PROGRAM NAME: /trainee/jrhull/ma/reg00_08.do     */
/* PROGRAMER: jrhull                                */
/* DATE: 2006 February 18                           */
/*                                                  */ 
/* PURPOSE: TEST ALTERNATE SPECIFICATIONS OF IV'S   */
/*          USING 3-year WINDOW (NOT 6-year)        */


/* 2000 DATA */

capture log close
log using reg00_08, replace text

use help0003.dta, replace


gen cows0=cows
gen cows1_6=cows
gen cows7pls=cows
recode cows0 (0=1) (1/6=0) (7/312=0) (.=.)
recode cows1_6 (0=0) (1/6=1) (7/312=0) (.=.)
recode cows7pls (0=0) (1/6=0) (7/312=1) (.=.)

gen pigs0=pigs
gen pigs1=pigs
recode pigs0 (0=1) (1/800=0) (9999=.) (.=.)
recode pigs1 (0=0) (1/800=1) (9999=.) (.=.)


/* Descriptive Analysis */


summarize helpdv2 nummigt2 numrrcd3 numrsnd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs0 pigs1 cows0 cows1_6 cows7pls charcoal lowest middle highest vill1365 vill_rai

 
/* Collinearity Check */

reg helpdv2 nummigt2 numrrcd3 numrsnd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai

vif


/* Full Model - Number migrants only */

mlogit helpdv2 nummigt2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummigt2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummigt2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Full Model - Number remitters (new variable) only */

mlogit helpdv2 numrrcd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numrrcd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numrrcd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Full Model - Number sent (new variable) only */

mlogit helpdv2 numrsnd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numrsnd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numrsnd3 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

