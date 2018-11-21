*! assertlist_cleanup version 1.09 - Biostat Global Consulting - 2018-11-21

* This program can be used after assertlist to cleanup the column
* names and make them more user friendly

*******************************************************************************
* Change log
* 				Updated
*				version
* Date 			number 	Name			What Changed
* 2018-02-08	1.00	MK Trimner		Original Version
* 2018-04-10	1.01	MK Trimner		Added sorting option and broke into programs
* 2018-05-10	1.02	MK Trimner		Corrected typo
* 2018-06-06	1.03	MK Trimner		Added code to strip .xls or .xlsx extension
* 2018-09-13	1.04	MK Trimner		Added code to destring id variables when possible
*										Had to add code to create a temp string variable as well
*										in rename program
* 2018-09-27	1.05	MK Trimner		Added code to string .xls or .xlsx extension from NAME
* 2018-10-04	1.06	MK Trimner		Added a min of 30 for column width to prevent errors with 
*										column widths that are too long
* 										Also added txtwrap for entire sheet after all other formatting
*										is completed.
* 2018-10-10	1.07	MK Trimner		Corrected message
* 2018-10-24	1.08	Dale Rhoda		Use numtobase26() to pull the Excel column name we need
* 2018-11-21	1.09	MK Trimner		-Removed CONCATENATE formula (Replace command) and put
*										in replace program to speed up process.
*										- Added code to set column width to 0 if 
*										replace column or var type
*******************************************************************************
*
* Contact Dale Rhoda (Dale.Rhoda@biostatglobal.com) with comments & suggestions.
*

program define assertlist_cleanup

	syntax  , EXCEL(string asis) [ NAME(string asis) IDSORT ]
	

	noi di as text "Confirming excel file exists..."
	
	* If the user specified a .xls or .xlsx extension in NAME or EXCEL, strip it off here
	foreach v in excel name {
		if lower(substr("``v''",-4,.)) == ".xls"  ///
			local `v' `=substr("``v''",1,length("``v''")-4)'
		if lower(substr("``v''",-5,.)) == ".xlsx" ///
			local `v' `=substr("``v''",1,length("``v''")-5)'
	}

	* Make sure file provided exists
	capture confirm file "`excel'.xlsx"
	if _rc!=0 {
		* If file not found, display error and exit program
		noi di as error "Spreadsheet provided in macro EXCEL does not exist." ///
				" Current value provided was: `excel'"
				
		noi di as error "Exiting program..."
		exit 99
				
	}
	else {
		
		* Describe excel file to determine how many sheets are present
		capture import excel using "`excel'.xlsx", describe
		local f `=r(N_worksheet)'
			
		* If user requests a new file name, create copy and save as NAME
		if "`name'"!="" {
			noi di as text "Making copy of excel file named: `name'.xlsx..."
			copy "`excel'.xlsx" "`name'.xlsx", replace
			
			* Set excel local to new file name
			local excel `name'
		}

		* Go through each of the sheets
		forvalues b = 1/`f' {
			
			* Bring in the sheet
			capture import excel using "`excel'.xlsx", describe
			
			* Capture the sheet name			
			local sheet `=r(worksheet_`b')'
		
			* Import file
			noi di as text "Importing excel sheet: `sheet'..."
			import excel "`excel'.xlsx", sheet("`sheet'") firstrow clear allstring
			
			* Create a local with the cell range for sheet
			local range `=r(range_`b')'
				
			* Set local for max number of vars checked
			local max 0
			
			* If it is a fix sheet, sort the variables by id
			if "`=strpos("`sheet'","fix")'"!="0" {
			
				* Grab the max number of vars checked
				qui {
					capture confirm var _al_num_var_checked
					if _rc==0 {
						tempvar num_var_checked_l
						destring _al_num_var_checked, gen(`num_var_checked_l')
						qui summarize `num_var_checked_l'
						local max `=r(max)'
						drop `num_var_checked_l'
					}
				}
				if "`idsort'"!="" assertlist_cleanup_idsort, excel(`excel') sheet(`sheet')  max(`max')
			}
	
			* Remove _al from var names
			local n 1

			noi di as text "Renaming variables and formatting columns..."
			foreach v of varlist * {
				
				* Rename all the variables
				assertlist_cleanup_rename, excel(`excel') sheet(`sheet') n(`n') ///
					max(`max') var(`v')
				
				* Format the tabs
				assertlist_cleanup_format, excel(`excel') sheet(`sheet') n(`n') ///
					m1(`m`n'1') m2(`m`n'2') type(`type') replace(`replace') 
				
				local ++n
			}
			
		* Wrap text
		putexcel (`range'), txtwrap
		}
	}

end


********************************************************************************
********************************************************************************
******							Assertlist Cleanup Sort					   *****
********************************************************************************
********************************************************************************
capture program drop assertlist_cleanup_idsort
program define assertlist_cleanup_idsort

	syntax, EXCEL(string asis) SHEET(string asis) MAX(int)

	noi di as text "Sort sheet by ID Variables..."

	qui {
		* Double check that IDlist provided is the same as previously used
		local e
		foreach v of varlist * {
			if strpos("`e'","_al_assertion_syntax")==0  {
				local e `e' `v' 
			}
		}
			
		* Determine the number of words in previous IDlist
		* Need to subtract 1 as _al_assertion_syntax is included in list
		local enum = `= wordcount("`e'") - 1'
			
		* Create local with the idlist
		* Start at the 3rd word in `e' as the first two are 
		* check_sequence and num_var_checked
		local elist
		forvalues i = 3/`enum' {
			local elist `elist' `=word("`e'",`i')'
		}
							
		* sort by the ids found in elist
		sort `elist'
		
		* Export the new sorted data
		export excel using "`excel'.xlsx", sheet("`sheet'") sheetmodify ///
					firstrow(var) nolabel datestring("%tdDD/Mon/CCYY")
				
	}
end

********************************************************************************
********************************************************************************
******						Rename Excel Variables 						   *****
********************************************************************************
********************************************************************************
capture program drop assertlist_cleanup_rename
program define assertlist_cleanup_rename

syntax  , EXCEL(string asis) SHEET(string asis) N(int) MAX(int) VAR(varlist)

	qui {

		local v `var'
		
		* Reset two locals that will be trigger column width formatting
		local type
		local replace
		
		* Grab the max length for formatting
		tempvar `v'_l
		if substr("`: type `v''",1,3) != "str" tostring(`v'), replace
		gen ``v'_l'=length(`v')
		
		qui summarize ``v'_l'
		local m`n'1=`=r(max) + 1'

		drop ``v'_l'
					
		local `v' `=subinstr("`v'","_al_","",1)'
			
		* Grab the var name and placement for putexcel purpose
		local `v'n `n'
			
		if "``v''"=="check_sequence" 	local `v' Assertion Completed Sequence Number 
		if "``v''"=="obs_number" 		local `v' Observation Number in Dataset 
		if "``v''"=="assertion_syntax"	local `v' Assertion Syntax That Failed
		if "``v''"=="tag" 				local `v' User Specified Additional Information
		if "``v''"=="total"				{
			local `v' Total Number of Observations Included in Assertion
			local m`n'1 17
		}	
		if "``v''"=="number_passed"		local `v' Number That Passed Assertion
		if "``v''"=="number_failed"		local `v' Number That Failed Assertion
		if "``v''"=="note1"				local `v' Note
		if "``v''"=="num_var_checked"	local `v' Number of Variables Checked in Assertion
		
		if `max'!=0 {
			forvalues i = 1/`max' {
				if "``v''"=="var_`i'"			local `v' Name of Variable `i'  Checked in Assertion
				if "``v''"=="var_type_`i'"		{
					local `v' Value type of Variable `i'
					local type yes
				}
				if "``v''"=="original_var_`i'"	local `v' Current Value	of Variable `i'
				if "``v''"=="correct_var_`i'"	{
					local `v' Blank Space for User to Provide Correct Value of Variable `i' 
					local m`n'1 20
				}
				if "``v''"=="replace_var_`i'"	{
					local `v' Stata Code to Be Used to Replace Current Value with Correct Value for Variable `i'
					local replace yes
				}
			}
		}
		
		* also create local with max of variable name
		local m`n'2 =length("``v''")
							
		* Put the new variable name into excel file
		putexcel set "`excel'.xlsx", modify sheet("`sheet'") 

		mata: st_local("xlcolname", invtokens(numtobase26(``v'n')))
		putexcel `xlcolname'1 = "``v''", txtwrap
	
		* Pass through the locals
		foreach v in m`n'1 m`n'2 type replace {
			c_local `v' ``v''
		}
	}
end

********************************************************************************
********************************************************************************
******							Format Excel Tabs						   *****
********************************************************************************
********************************************************************************

capture program drop assertlist_cleanup_format
program define assertlist_cleanup_format

syntax  , EXCEL(string asis) SHEET(string asis) N(int) M1(int) M2(int) ///
		[type(string asis) replace(string asis)]
	
	* Format the width of each column
	* use mata to populate table formatting
	qui {
		mata: b = xl()
		mata: b.load_book("`excel'.xlsx")
		mata: b.set_mode("open")
		
		mata: b.set_sheet("`sheet'")
		
		if `m2'>`m1'	mata: b.set_column_width(`n',`n',`=min(30,`=`m1'+ 11')')
		else 			mata: b.set_column_width(`n',`n',`=min(30,`=`m1'+3')')
		
		foreach l in type replace {
			if "``l''"=="yes" mata: b.set_column_width(`n',`n',0)
		}
		
		* Set the row height 
		mata: b.set_row_height(1,1,90)
		
		mata b.close_book()		
	}
end


