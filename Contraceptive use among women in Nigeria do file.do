*This analysis used the DHS Nigeria 2018 IR file. The aim is to study the trends on contraceptive usage among women. *It is often observed that despite 
*knowledge about contraception the usage remains low. *Regression analysis was used to study what effect some select factors have on contraception usage. 
*This repository contains the do files. The analysis done on Stata 13.

*1.First, we start by tabulating the main variable V312
tab V312
*Next, change the variable to remove people who report they have never had sex to make your work easier
replace V312=. if [V312==0 & V364==5]
*New variable has been created to remove people who have never had sex from V312. 
*Now, create a variable to ccount for whether people use contraceptive methods (any method). 
gen contra_use=.
replace contra_use=0 if [V312==0]
replace contra_use=1 if [V312>=1 & V312<=18]
lab define i_contra_use 0 No 1 Yes
label value contra_use i_contra_use 
*Next step, add weight to the cluster. DHS Program (www.dhsprogram.com) recommends all analysis using DHS sets should include weights to avoid wrong inferences
gen wt= V005/100000
svyset V001 [pweight=wt]

*2. Next step, crosstabulate the main variable with other variables*
*religion
svy: tab V312 V130,col
*wealth index
svy: tab V312 V190, col
*highest educational level
svy: tab V312 V106, col
*type of place of residence urban/rural
svy: tab V312 V025, col
*3. Cross tabulate the new variable with the same variable as before
*religion
svy: tab contra_use V130, col
*wealth index
svy: tab contra_use V190, col
*highest educational level
svy: tab contra_use V106, col
*type of place of residence urban/rural
svy: tab contra_use V025, col 
gen religion=.
replace religion=0 if V130==1
replace religion=1 if V130==2
replace religion=2 if V130==3
replace religion=3 if V130==4
replace religion=4 if V130==5
replace religion=5 if V130==6
gen urban=.
replace urban=0 if V025==2
replace urban=1 if V025==1
gen wealth=.
replace wealth=0 if V190==1
replace wealth=1 if V190==2
replace wealth=2 if V190==3
replace wealth=3 if V190==4
replace wealth=4 if V190==5
pwcorr contra_use religion ,obs sig
svy: regress contra_use religion
svy: regress contra_use i.religion
pwcorr contra_use wealth ,obs sig
svy: regress contra_use wealth
svy: regress contra_use i.wealth
pwcorr contra_use urban ,obs sig
svy: regress contra_use urban
pwcorr contra_use V106, obs sig
svy: regress contra_use V106
svy: regress contra_use i.V106
pwcorr contra_use urban religion V106 wealth ,obs sig
pwcorr contra_use religion wealth urban V106 ,obs sig
svy:reg contra_use religion wealth urban V106 
svy:reg contra_use i.religion i.wealth i.urban i.V106
