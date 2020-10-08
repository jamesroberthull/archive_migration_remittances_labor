/* PROGRAM NAME: /trainee/jrhull/ma/reg94_01.do     */
/* PROGRAMER: jrhull                                */
/* DATE: 2005 October 14                            */
/*                                                  */ 
/* PURPOSE: GENERATE MNL MODELS FOR MA              */


/* 1994 DATA */

capture log close
log using reg94_01, replace text

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

/* Descriptive Work */

/* histogram logmnage 
histogram meanage
histogram cows
histogram pigs */


/* Simplest model */

mlogit helpdv2 nummigt, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 nummigt, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 nummigt, robust cluster(vill94) basecategory(2)          



/* One-variable model - number of remitters */

mlogit helpdv2 numrrcd2, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numrrcd2, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numrrcd2, robust cluster(vill94) basecategory(2)          



* One-variable model - number of migrants receiving money */

mlogit helpdv2 numrsnd2, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numrsnd2, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numrsnd2, robust cluster(vill94) basecategory(2)          

 
/* Full Model - Revised Remittance Variables */

mlogit helpdv2 nummigt numrrcd2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummigt numrrcd2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummigt numrrcd2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Full Model - male and female migrants separate */

mlogit helpdv2 nummigm nummigf numrrcd2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummigm nummigf numrrcd2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummigm nummigf numrrcd2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Collinearity Check */

reg helpdv2 nummigt numrrcd2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai

vif


/* Full Model - Number migrants only */

mlogit helpdv2 nummigt m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummigt m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummigt m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Full Model - Number remitters (new variable) only */

mlogit helpdv2 numrrcd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numrrcd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numrrcd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


/* Full Model - Number sent (new variable) only */

mlogit helpdv2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numrsnd2 m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)
