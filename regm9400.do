/* PROGRAM NAME: /trainee/jrhull/ma/regm9400.do     */
/* PROGRAMER: jrhull                                */
/* DATE: 2006 January 24                            */
/*                                                  */ 
/* PURPOSE: GENERATE MNL MODELS FOR MA (Merged)     */


/* 1994-2000 Match Merged Dataset */

log close
log using regm9400, replace text

use merg9400.dta, replace

gen cows094=cows94
gen cows1694=cows94
gen cows7p94=cows94
recode cows094 (0=1) (1/6=0) (7/122=0) (.=.)
recode cows1694 (0=0) (1/6=1) (7/122=0) (.=.)
recode cows7p94 (0=0) (1/6=0) (7/122=1) (.=.)

gen pigs094=pigs_94
gen pigs194=pigs_94
recode pigs094 (0=1) (1/110=0) (.=.)
recode pigs194 (0=0) (1/110=1) (.=.)

gen helpd394=helpd194
gen helpd300=helpd100
recode helpd394 (1=1) (2=2) (3/4=3) (5=4) (6/7=5)
recode helpd300 (1=1) (2=2) (3/4=3) (5=4) (6/7=5)

tab helpd194 helpd100, cell col row 
tab helpd394 helpd300, cell col row 
tab helpd294 helpd200, cell col row 

/* Simplest model */

mlogit helpd200 nummig94 nummig00, robust cluster(vill94) basecategory(4)          

mlogit helpd200 nummig94 nummig00, robust cluster(vill94) basecategory(3)          

mlogit helpd200 nummig94 nummig00, robust cluster(vill94) basecategory(2)          



/* One-variable model - number of remitters */

mlogit helpd200 numrcd94 nummig00, robust cluster(vill94) basecategory(4)          

mlogit helpd200 numrcd94 nummig00, robust cluster(vill94) basecategory(3)          

mlogit helpd200 numrcd94 nummig00, robust cluster(vill94) basecategory(2)          



* One-variable model - number of migrants receiving money */

mlogit helpd200 numsnd94 numsnd00, robust cluster(vill94) basecategory(4)          

mlogit helpd200 numsnd94 numsnd00, robust cluster(vill94) basecategory(3)          

mlogit helpd200 numsnd94 numsnd00, robust cluster(vill94) basecategory(2)          

 

/* Full Model - Number migrants only w/ codetwo */

mlogit helpd200 nummig94 nummig00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(4)

mlogit helpd200 nummig94 nummig00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(3)

mlogit helpd200 nummig94 nummig00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(2)


/* Full Model - Number remitters (new variable) only */

mlogit helpd200 numrcd94 numrcd00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(4)

mlogit helpd200 numrcd94 numrcd00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(3)

mlogit helpd200 numrcd94 numrcd00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(2)


/* Full Model - Number sent (new variable) only */

mlogit helpd200 numsnd94 numsnd00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(4)

mlogit helpd200 numsnd94 numsnd00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(3)

mlogit helpd200 numsnd94 numsnd00 code2_94 m1365_94 f1365_94 numdep94 mnage_94 cass_94 cott_94 pigs194 cows1694 cows7p94 char_94 mid_94 high_94 v1365_94 vrai_94, robust cluster(vill94) basecategory(2)




