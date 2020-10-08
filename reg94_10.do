/* PROGRAM NAME: /trainee/jrhull/ma/reg94_10.do     */
/* PROGRAMER: jrhull                                */
/* DATE: 2006 February 28                           */
/*                                                  */ 
/* PURPOSE: GENERATE MNL MODELS FOR MA (W/CODETWO)  */
/*          USING TIME-UNLIMITED REMITTANCE VAR'S   */

/* 1994 DATA */

capture log close
log using reg94_10, replace text

use help9403.dta, replace

gen logmnage=log(meanage)

gen cows0=cows
gen cows1_6=cows
gen cows7pls=cows
recode cows0 (0=1) (1/6=0) (7/122=0) (.=.)
recode cows1_6 (0=0) (1/6=1) (7/122=0) (.=.)
recode cows7pls (0=0) (1/6=0) (7/122=1) (.=.)

gen pigs0=pigs
gen pigs1=pigs
recode pigs0 (0=1) (1/110=0) (.=.)
recode pigs1 (0=0) (1/110=1) (.=.)


/* Descriptives */

summarize helpdv2 nummigt numremit numsend codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs0 pigs1 cows0 cows1_6 cows7pls charcoal lowest middle highest vill1365 vill_rai

 
/* Collinearity Check */

reg helpdv2 nummigt numremit numsend codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai

vif


/* Full Model - Number migrants only */

mlogit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Full Model - Number remitters (new variable) only */

mlogit helpdv2 numremit codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numremit codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numremit codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Full Model - Number sent (new variable) only */

mlogit helpdv2 numsend codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numsend codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numsend codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)

