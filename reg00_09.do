/* PROGRAM NAME: /trainee/jrhull/ma/reg00_09.do     */
/* PROGRAMER: jrhull                                */
/* DATE: 2006 February 18                           */
/*                                                  */ 
/* PURPOSE: TEST IAA ASUMPTION                      */


/* 2000 DATA */

capture log close
log using reg00_09, replace text

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


/* Full Model - Number migrants only */

quietly: mlogit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

set seed 1010101

mlogtest, smhsiao

quietly: mlogit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

set seed 1010102

mlogtest, smhsiao

quietly: mlogit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

set seed 1010103

mlogtest, smhsiao

mlogtest, hausman base


/* Full Model - Number remitters (new variable) only */

quietly: mlogit helpdv2 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

set seed 1010104

mlogtest, smhsiao

quietly: mlogit helpdv2 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)


set seed 1010105

mlogtest, smhsiao

quietly: mlogit helpdv2 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

set seed 1010106

mlogtest, smhsiao

mlogtest, hausman base

/* Full Model - Number sent (new variable) only */

quietly: mlogit helpdv2 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

set seed 1010107

mlogtest, smhsiao

quietly: mlogit helpdv2 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)


set seed 1010108

mlogtest, smhsiao

quietly: mlogit helpdv2 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

set seed 1010109

mlogtest, smhsiao

mlogtest, hausman base
