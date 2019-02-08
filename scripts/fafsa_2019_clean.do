/*******************************************************************************
PROJECT:		2018-19 Cycle FAFSA Analysis
CREATOR:		Katharine Meyer (kem3e)
DATE STARTED:	10/16/2017

FILE PURPOSE:	Clean Files

*******************************************************************************/

*Later weeks where I figured out how to skip manually changing files
capture program drop fafsa_clean
program fafsa_clean
	args date currentyear lastyear week date2 date3
	
	foreach state in $state {
	clear
	use "$sdrive/`state'_`date'_raw.dta"
	
	rename freeapplicationforfederalstu name
	rename b city
	rename c state
	rename d submit_`currentyear'
	rename e complete_`currentyear'
	rename f submit_`lastyear'
	rename g complete_`lastyear'
	
	foreach var in submit_`currentyear' complete_`currentyear' submit_`lastyear' complete_`lastyear' {
		replace `var' = "0" if `var'=="<5"
		destring `var', replace
		}
	egen state_total_comp_`currentyear' = total(complete_`currentyear')
	egen state_total_comp_`lastyear' = total(complete_`lastyear')

	egen state_total_sub_`currentyear' = total(submit_`currentyear')
	egen state_total_sub_`lastyear' = total(submit_`lastyear')

	egen city_total_comp_`currentyear' = total(complete_`currentyear'), by(city)
	egen city_total_comp_`lastyear' = total(complete_`lastyear'), by(city)

	egen city_total_sub_`currentyear' = total(submit_`currentyear'), by(city)
	egen city_total_sub_`lastyear' = total(submit_`lastyear'), by(city)

	drop if name==""
	
	gen cycle = 1819
	
	keep name city state cycle submit* complete* state_total* city_total*
	save "$tdrive/`state'_`date'_clean.dta", replace
	}
end

fafsa_clean "Oct05" "100518" "100517"
fafsa_clean "Oct12" "101218" "101217"
fafsa_clean "Oct19" "101918" "101917"
fafsa_clean "Oct26" "102618" "102617"
fafsa_clean "Nov02" "110218" "110217"
fafsa_clean "Nov09" "110918" "110917"
*fafsa_clean "Nov16" "111618" "111617"
fafsa_clean "Nov23" "112318" "112317"
fafsa_clean "Nov30" "113018" "113017"
fafsa_clean "Dec07" "120718" "120717"
fafsa_clean "Dec14" "121418" "121417"
fafsa_clean "Dec28" "122818" "122817"
fafsa_clean "Jan04" "10419" "10418"
fafsa_clean "Jan11" "11119" "11118"
fafsa_clean "Jan25" "12519" "12518"
fafsa_clean "Feb01" "20119" "20118"

