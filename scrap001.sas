*********************************************************************
Program:  timeaway.sas

Date:  June 21, 2005

--------------------------------------------------

--------------------------------------------------

Input data:  /nangrong/data_sas/2000/current/indiv.03
             /nangrong/data_sas/2000/current/hh.03
*********************************************************************;

options linesize=100 pagesize=73;

libname in1 xport '/nangrong/data_sas/2000/current/hh00.03';
libname in2 xport '/nangrong/data_sas/2000/current/indiv00.03';

***************************
*  Merge INDIV00 to HH00  *
***************************;

data migrants;
  merge in1.hh00(keep=HHID00 INTMNTH1-INTMNTH6 INTDAY1-INTDAY6 INTRES1-INTRES6 in=a)
        in2.indiv00(keep=HHID00 CEP00 X1 CODE2 X7D X7M X7Y in=b);
  by HHID00;

  if (a=1 and b=1) and (X1=3);

*** Create # Days Away ***;

if (X7D=99 or X7M=99 or X7Y=99) or (X7M=. and X7Y=.) then DAYSGONE=99999;
  else if (X7D=. and X7Y ne .) then DAYSGONE=(X7Y*365);
  else DAYSGONE=X7D+(X7M*30)+(X7Y*365);

*** Create MONTH and DAY ***;

array iv1 {6} INTRES1-INTRES6;
array iv2 {6} INTDAY1-INTDAY6;
array iv3 {6} INTMNTH1-INTMNTH6;

do i=1 to 6;
 if iv1{i}=1
   then do;
         DAY=iv2{i};
         MONTH=iv3{i};
        end;
end;

YEAR=2000;

*** Create IVDATE ***;

if DAY in(' ','99') or MONTH in(' ','99') then IVDATE=' ';
  else IVDATE=MONTH||DAY||YEAR;

if MONTH=99 or DAY=99 then IDATE=.;
  else IDATE=MDY(MONTH,DAY,YEAR);

HDATE=MDY(10,1,1999);

DDATE=IDATE-HDATE;

run;

*** Frequency ***;

proc freq data=migrants;
  tables IDATE HDATE DDATE;
*  tables DAYSGONE MONTH DAY YEAR IVDATE;
run;

*** Print ***;

proc print data=migrants(obs=100);
  id HHID00 CEP00;
  var MONTH DAY YEAR IDATE HDATE DDATE;
run;

proc print data=migrants;
  id HHID00 CEP00;
  var DAYSGONE X7D X7M X7Y;
  where DAY=.;
run;
