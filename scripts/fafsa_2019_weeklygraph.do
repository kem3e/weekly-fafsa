/*******************************************************************************
PROJECT:		2018-19 Cycle FAFSA Analysis
CREATOR:		Katharine Meyer (kem3e)
DATE STARTED:	11/29/2017

FILE PURPOSE:	Exploratory analses
*******************************************************************************/

*Examine differences in weekly fililing rates
clear
use "$tdrive/national_byweek.dta"
	gen schid = _n //need arbitrary ID numbers for reshaping
	*Graph the average number of submissions each weeek
	*graph bar submit_100617 submit_101317 submit_102017 submit_102717

	reshape long submit_ complete_ state_total_comp_ state_total_sub_ city_total_comp_ city_total_sub_, i(schid) j(date)
	
	save "$tdrive/national_byweek_long.dta", replace
	
	clear
	use "$tdrive/national_byweek_long.dta"
		capture drop _merge
	*Fix dates
	order schid name date submit_ complete_
		*br schid name date submit_ complete_
	*Fix dates
		gen str6 date_string = string(date, "%06.0f")
		gen month = substr(date_string, 1, 2)
		gen day = substr(date_string, 3, 2)
		gen year_short = substr(date_string, -2, .)
		gen year_front = "20"
		gen year = year_front+year_short
		gen day_month = month+day
			destring month day year, replace
		gen fafsa_date = mdy(month, day, year)
	gen current = (fafsa_date>=21462) //on or after first 1819 cycle report
	gen cycle_year = 1920 if current==1
		replace cycle_year = 1819 if current==0
		*br schid cycle_year year date
	order schid cycle_year year date
	sort schid cycle_year year date
	egen week = tag(schid cycle_year)
		replace week = week[_n-1]+1 if schid==schid[_n-1] & cycle_year==cycle_year[_n-1]
		label var week "Week in FAFSA Cycle"
		capture drop date date_string year_short year current fafsa_date
	gen week_name = ""
		replace week_name = "Oct 5" if week==1
		replace week_name = "Oct 12" if week==2
		replace week_name = "Oct 19" if week==3
		replace week_name = "Oct 26" if week==4
		replace week_name = "Nov 02" if week==5
		replace week_name = "Nov 09" if week==6
		*figure out nov. 16
		replace week_name = "Nov 23" if week==7
		replace week_name = "Nov 30" if week==8
		replace week_name = "Dec 07" if week==9
		replace week_name = "Dec 14" if week==10
		replace week_name = "Dec 28" if week==11
		replace week_name = "Jan 04" if week==12
		replace week_name = "Jan 11" if week==13
		replace week_name = "Jan 25" if week==14
		replace week_name = "Feb 01" if week==15
*		replace week_name = "Mon #" if week==#
		
	egen national_total_sub = total(submit_), by(week cycle_year)
	egen national_total_comp = total(complete_), by(week cycle_year)
	gen national_enroll = 3459600 if cycle_year==1819 //WICHE estimated 12th grade graduates
		//https://knocking.wiche.edu/nation-region-profile/
		replace national_enroll = 3385900 if cycle_year==1718
	mdesc national_total_comp national_total_sub national_enroll
				
	capture drop treat post treatpost national_total_sub national_total_comp national_enroll
		
	*Reshape for graphing
	reshape wide submit_ complete_ state_total_comp_ state_total_sub_ city_total_comp_ city_total_sub_ national_total_sub national_total_comp national_enroll, i(schid day_month) j(cycle_year)

	*br name week day_month submit_1718 submit_1819
	sort name week day_month submit_1819 submit_1920
	order name week day_month submit_1819 submit_1920

	foreach var in submit_1819 submit_1920 {
		replace `var' = 0 if `var'==.
		}
	egen weekly_national_19 = total(submit_1920), by(week)
	egen weekly_national_18 = total(submit_1819), by(week)
	egen weekly_national_19_c = total(complete_1920), by(week)
	egen weekly_national_18_c = total(complete_1819), by(week)

	foreach var in weekly_national_18 weekly_national_19 weekly_national_18_c weekly_national_19_c {
		replace `var' = `var'/1000
		}
	
save "$tdrive/national_clean_wide.dta", replace	

clear
use "$tdrive/national_clean_wide.dta"
	
graph bar weekly_national_18 weekly_national_19, over(week_name, sort(week) ///
	label(angle(45) labsize(vsmall))) ///
	title("Cumulative Weekly FAFSA Submissions", size(medium)) ///
	ytitle("Total FAFSAs submitted" "in thousands" "", size(small)) ///
	b1title("Week in Cycle" "", size(small)) ///
	legend(order(1 "2018-19 Cycle" 2 "2019-20 Cycle")) ///
	blabel(bar, format(%4.0f) size(tiny)) ///
	graphregion(color(white)) ///
	note("Note: Includes 50 states plus the District of Columbia", size(vsmall))
	graph save "$odrive/weekly_submission_comparison.gph", replace
