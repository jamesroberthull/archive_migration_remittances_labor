* PROGRAM NAME: /trainee/jrhull/ma/reg00_04.do      */
/* PROGRAMER: jrhull                                */
/* DATE: 2006 January 25                            */
/*                                                  */ 
/* PURPOSE: GENERATE MN PROBIT MODELS FOR MA        */


/* 2000 DATA */

capture log close
log using reg00_04, replace text

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

/* Simplest model */

mprobit helpdv2 nummigt, robust baseoutcome(4)          

mprobit helpdv2 nummigt, robust baseoutcome(3)          

mprobit helpdv2 nummigt, robust baseoutcome(2)          



/* One-variable model - number of remitters */

mprobit helpdv2 numrrcd2, robust baseoutcome(4)          

mprobit helpdv2 numrrcd2, robust baseoutcome(3)          

mprobit helpdv2 numrrcd2, robust baseoutcome(2)          



* One-variable model - number of migrants receiving money */

mprobit helpdv2 numrsnd2, robust baseoutcome(4)          

mprobit helpdv2 numrsnd2, robust baseoutcome(3)          

mprobit helpdv2 numrsnd2, robust baseoutcome(2)          



/* Full Model - Number migrants only */

mprobit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(4)

mprobit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(3)

mprobit helpdv2 nummigt codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(2)


/* Full Model - Number remitters (new variable) only */

mprobit helpdv2 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(4)

mprobit helpdv2 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(3)

mprobit helpdv2 numrrcd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(2)


/* Full Model - Number sent (new variable) only */

mprobit helpdv2 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(4)

mprobit helpdv2 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(3)

mprobit helpdv2 numrsnd2 codetwo m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust baseoutcome(2)
