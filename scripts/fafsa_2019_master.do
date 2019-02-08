/*******************************************************************************
PROJECT:		2018-19 Cycle FAFSA Analysis
CREATOR:		Katharine Meyer (kem3e)
DATE STARTED:	10/16/2017

FILE PURPOSE:	Master do.file

*******************************************************************************/

/*
	WEEKLY DOWNLOAD NOTES:
	-Update "dates_all" global with most recent week
	-Update "date_cont" global with most recent week
	-Add most recent week into import file
	-Add most recent week into clean file
	-No changes needed to merge & append files since pull on $dates_all and $dates_cont
	-Add "week name" code line in "weeklygraph" for nice graphing
*/

global user = c(username)
global drive "C:\Users/$user/Box Sync/FAFSA research/FAFSA 2019" //update to where files stored on your computer

global ddrive "$drive/Do Files" //storage for do.files
global edrive "$drive/Excel - Weekly" //storage for downloaded FAFSA weekly counts (raw & clean)
global sdrive "$drive/Stata Files - Raw" //storage for imported FAFSA weekly counts
global tdrive "$drive/Stata Files - Temp" //storage for clean FAFSA weekly counts
global odrive "$drive/output"
global state "AK AL AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY"
global state_cont "AL AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY"
global state_nopr "AK AL AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY"
	*Drop first state for merging/appending macros
global dates_all "Oct05 Oct12 Oct26 Nov02 Nov09 Nov23 Nov30 Dec07 Dec14 Dec28 Jan04 Jan11 Jan25 Feb01" //Figure out Nov16
global dates_cont "Oct12 Oct19 Oct26 Nov02 Nov09 Nov23 Nov30 Dec07 Dec14 Dec28 Jan04 Jan11 Jan25 Feb01" //Figure out Nov16
	*Drop first date for merging/appending macros
			
do "$ddrive/fafsa_2019_import.do"
	*Imports cleaned Excel files from $edrive
	*Saves raw version in $sdrive
	
do "$ddrive/fafsa_2019_clean.do"	
	*Cleans raw weekly counts from $sdrive
	*Saves in $tdrive

do "$ddrive/fafsa_2019_merge.do"
	*Creates week-by-week file within each state
	
do "$ddrive/fafsa_2019_append.do"
	*Creates national file for each week

do "$ddrive/fafsa_2019_weeklygraph.do"
	*Makes a weekly bar graph of filing
