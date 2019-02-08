/*******************************************************************************
PROJECT:		2018-19 Cycle FAFSA Analysis
CREATOR:		Katharine Meyer (kem3e)
DATE STARTED:	10/16/2017

FILE PURPOSE:	Append

*******************************************************************************/

*Append each state (Long for each week)
foreach week in $dates_all {
	
	clear
	use "$tdrive/AK_`week'_clean.dta"

		foreach state in $state_cont {
			capture append using "$tdrive/`state'_`week'_clean.dta"
			}	
	save "$tdrive/national_`week'.dta", replace
}


*Append each state (Long national)
	clear
	use "$tdrive/AK_byweek.dta"

		foreach state in $state_cont {
			capture append using "$tdrive/`state'_byweek.dta"
			}	
	save "$tdrive/national_byweek.dta", replace
