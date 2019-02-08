/*******************************************************************************
PROJECT:		2018-19 Cycle FAFSA Analysis
CREATOR:		Katharine Meyer (kem3e)
DATE STARTED:	10/16/2017

FILE PURPOSE:	Merge state-by-week dataset
				(Wide)

*******************************************************************************/

clear
foreach state in $state {
	clear
	use "$tdrive/`state'_Oct05_clean.dta"
	foreach date in $dates_cont {
		capture drop _merge
		capture merge 1:1 name city using "$tdrive/`state'_`date'_clean.dta"
	}
	save "$tdrive/`state'_byweek.dta", replace
}


