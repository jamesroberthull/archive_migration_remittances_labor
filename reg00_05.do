/* PROGRAM NAME: /trainee/jrhull/ma/reg00_05.do     */
/* PROGRAMER: jrhull                                */
/* DATE: 2005 October 14                            */
/*                                                  */ 
/* PURPOSE: GENERATE MNL MODELS FOR MA (5-Category) */
 

/* 2000 DATA */

capture log close
log using reg00_05, replace text

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


gen helpdv3=helpdv
recode helpdv3 (1=1) (2=2) (3/4=3) (5=4) (6/7=5)


/* Full Model - Number migrants only */

mlogit helpdv3 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(5)

mlogit helpdv3 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv3 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv3 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

mlogtest, combine



/* Full Model - Number remitters (new variable) only */

mlogit helpdv3 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(5)

mlogit helpdv3 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv3 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv3 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

mlogtest, combine



/* Full Model - Number sent (new variable) only */


mlogit helpdv3 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(5)

mlogit helpdv3 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv3 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv3 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

mlogtest, combine

