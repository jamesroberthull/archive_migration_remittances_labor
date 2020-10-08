/* PROGRAM NAME: /trainee/jrhull/ma/reg94_02.do     */
/* PROGRAMER: jrhull                                */
/* DATE: 2006 January 21                            */
/*                                                  */
/* PURPOSE: TEST FUNCTIONAL FORM OF KEY IV's        */


/* 1994 DATA */

capture log close
log using reg94_02, replace text

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

/* Create categorical variables for # Migrants & # Remitters */

gen nummig0=nummigt
gen nummig1=nummigt
gen nummig2=nummigt
gen nummig3p=nummigt

recode nummig0 (0=1) (1/9=0)
recode nummig1 (2/9=0)
recode nummig2 (1=0) (2=1) (3/9=0)
recode nummig3p (1/2=0) (3/9=1)

gen numrcd0=numrrcd2
gen numrcd1=numrrcd2
gen numrcd2=numrrcd2
gen numrcd3p=numrrcd2

recode numrcd0 (0=1) (1/7=0)
recode numrcd1 (2/7=0)
recode numrcd2 (1=0) (2=1) (3/7=0)
recode numrcd3p (1/2=0) (3/7=1)

gen numsnd0=numrsnd2
gen numsnd1=numrsnd2
gen numsnd2=numrsnd2
gen numsnd3p=numrsnd2

recode numsnd0 (0=1) (1/5=0)
recode numsnd1 (2/5=0)
recode numsnd2 (1=0) (2=1) (3/5=0)
recode numsnd3p (1/2=0) (3/5=1)



/* Simplest model */

mlogit helpdv2 nummig1 nummig2 nummig3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 nummig1 nummig2 nummig3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 nummig1 nummig2 nummig3p, robust cluster(vill94) basecategory(2) 


mlogit helpdv2 nummig0 nummig2 nummig3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 nummig0 nummig2 nummig3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 nummig0 nummig2 nummig3p, robust cluster(vill94) basecategory(2) 


mlogit helpdv2 nummig0 nummig1 nummig3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 nummig0 nummig1 nummig3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 nummig0 nummig1 nummig3p, robust cluster(vill94) basecategory(2) 



/* One-variable model - number of remitters */

mlogit helpdv2 numrcd1 numrcd2 numrcd3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numrcd1 numrcd2 numrcd3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numrcd1 numrcd2 numrcd3p, robust cluster(vill94) basecategory(2)          


mlogit helpdv2 numrcd0 numrcd2 numrcd3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numrcd0 numrcd2 numrcd3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numrcd0 numrcd2 numrcd3p, robust cluster(vill94) basecategory(2)          


mlogit helpdv2 numrcd0 numrcd1 numrcd3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numrcd0 numrcd1 numrcd3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numrcd0 numrcd1 numrcd3p, robust cluster(vill94) basecategory(2)          



* One-variable model - number of migrants receiving money */

mlogit helpdv2 numsnd1 numsnd2 numsnd3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numsnd1 numsnd2 numsnd3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numsnd1 numsnd2 numsnd3p, robust cluster(vill94) basecategory(2)          


mlogit helpdv2 numsnd0 numsnd2 numsnd3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numsnd0 numsnd2 numsnd3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numsnd0 numsnd2 numsnd3p, robust cluster(vill94) basecategory(2)          


mlogit helpdv2 numsnd0 numsnd1 numsnd3p, robust cluster(vill94) basecategory(4)          

mlogit helpdv2 numsnd0 numsnd1 numsnd3p, robust cluster(vill94) basecategory(3)          

mlogit helpdv2 numsnd0 numsnd1 numsnd3p, robust cluster(vill94) basecategory(2)          

 
 

 
/* Full Model - Number migrants only */

mlogit helpdv2 nummig1 nummig2 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummig1 nummig2 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummig1 nummig2 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


mlogit helpdv2 nummig0 nummig2 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummig0 nummig2 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummig0 nummig2 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


mlogit helpdv2 nummig0 nummig1 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 nummig0 nummig1 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 nummig0 nummig1 nummig3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)



/* Full Model - Number remitters (new variable) only */

mlogit helpdv2 numrcd1 numrcd2 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numrcd1 numrcd2 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numrcd1 numrcd2 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


mlogit helpdv2 numrcd0 numrcd2 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numrcd0 numrcd2 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numrcd0 numrcd2 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


mlogit helpdv2 numrcd0 numrcd1 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numrcd0 numrcd1 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numrcd0 numrcd1 numrcd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)



/* Full Model - Number sent (new variable) only */

mlogit helpdv2 numsnd1 numsnd2 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numsnd1 numsnd2 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numsnd1 numsnd2 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


mlogit helpdv2 numsnd0 numsnd2 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numsnd0 numsnd2 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numsnd0 numsnd2 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)


mlogit helpdv2 numsnd0 numsnd1 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(4)

mlogit helpdv2 numsnd0 numsnd1 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(3)

mlogit helpdv2 numsnd0 numsnd1 numsnd3p m_13_65 f_13_65 numdeps meanage cassava cottage pigs1 cows1_6 cows7pls charcoal middle highest vill1365 vill_rai, robust cluster(vill94) basecategory(2)




         
