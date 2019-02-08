/*******************************************************************************
PROJECT:		2018-19 Cycle FAFSA Analysis
CREATOR:		Katharine Meyer (kem3e)
DATE STARTED:	10/16/2017

FILE PURPOSE:	Import Files

*******************************************************************************/

*Later weeks where I figured out how to skip manually changing files
**JUST CHANGE NAME OF SOME STATES TO (1) NOT (N)
**Check AL, GA, TN
capture program drop fafsa_newimport
program fafsa_newimport
	args date
	
	foreach state in $state {
		clear
		import excel "$edrive/`date'/`state'(1).xls", sheet("`state' 2019-20 Cycle") firstrow case(lower)
			drop in 1/3
		save "$sdrive/`state'_`date'_raw.dta", replace
	}
end

fafsa_newimport "Oct05"
fafsa_newimport "Oct12"
fafsa_newimport "Oct19"
fafsa_newimport "Oct26"
fafsa_newimport "Nov02"
fafsa_newimport "Nov09"
*fafsa_newimport "Nov16"
fafsa_newimport "Nov23"
fafsa_newimport "Nov30"
fafsa_newimport "Dec07"
fafsa_newimport "Dec14"
fafsa_newimport "Dec28"

*Tab names change every January
capture program drop fafsa_newimport
program fafsa_newimport
	args date
	
	foreach state in $state {
		clear
		import excel "$edrive/`date'/`state'(1).xls", sheet("`state' School Level Data") firstrow case(lower)
			drop in 1/3
		save "$sdrive/`state'_`date'_raw.dta", replace
	}
end
fafsa_newimport "Jan04"
fafsa_newimport "Jan11"
fafsa_newimport "Jan25"
fafsa_newimport "Feb01"
