{smcl}
{* *! version 1.0 06Oct2017}{...}
{vieweralsosee "[D] assert" "mansection D assert"}{...}
{viewerjumpto "Syntax" "assertlist_cleanup##syntax"}{...}
{viewerjumpto "Description" "assertlist_cleanup##description"}{...}
{viewerjumpto "Remarks" "assertlist_cleanup##remarks"}{...}
{title:Title}

{phang}
{bf:assertlist_cleanup} {hline 2} Cleans up excel file generated by {help assertlist}

{marker syntax}{...}
{title:Syntax}
{p 8 16 2}
{opt assertlist_cleanup}{cmd:,}   {it:{help assertlist_cleanup##excel:EXCEL}}(string) [ {it:{help assertlist_cleanup##name:NAME}}(string)
{it:{help assertlist_cleanup##idsort:IDSORT}} {it:{help assertlist_cleanup##format:FORMAT}}]
{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{pstd} {cmd:assertlist_cleanup} is a companion for the {help assertlist} command. {cmd:assertlist} lists observations that contradict an 
	assert command and provide details around WHICH rows failed the assertion, and HOW. {p_end}

{pstd} {cmd: assertlist_cleanup} takes the {cmd:assertlist} excel output and makes the column names 
	user friendly. It can also sort the result tabs based on the {help assertlist##idlist:IDLIST} provided during 
	the assertion if the {cmd:IDSORT} option is specified. {p_end}  
{pstd} {cmd:assertlist_cleanup} can only be used if the {help assertlist##excel:EXCEL} option was specified while running {cmd:assertlist}. 
	If the output file does not exist, the program will exit immediately. 
	{p_end}
	   
{hline}

{title:Required Input} 

{marker excel}
{pstd} {bf: EXCEL} - Name of the {help assertlist##excel:EXCEL} workbook that holds the {cmd:assertlist} output. {p_end}

{pmore} {it:*See {help assertlist_cleanup##note:NOTE} for additional information regarding {cmd:EXCEL}.}

{title:Optional Input} 
{marker name}
{pstd} {bf:NAME} - New name for Excel file. 

{pmore}	This option preserves the original {cmd:assertlist} Excel file and makes all changes to a copied version saved as {cmd:NAME}.{p_end}	 
{pmore} {it:*See {help assertlist_cleanup##note:NOTE} for additional information regarding {cmd:NAME}.} {p_end}

{pmore} {bf:Note: If NAME is not specified, the original Excel file is overwritten with new column names.} {p_end}
{marker note}	   
{pstd} {bf:NOTE: The input for {it:EXCEL} and {it:NAME} can include just the file name (goes to current folder) or a folder} 
        {bf: path and file name. Do {it:NOT} include double quotes around the path and filename for output Excel file.}{p_end}

{marker idsort}
{pstd} {bf:IDSORT} - Sorts each tab by the list of variables that uniquely identify each observation. These variables were provided in the {help assertlist##idlist:IDLIST} option in the original {cmd:assertlist} command.	{p_end}

{marker format}
{pstd} {bf:FORMAT} - {cmd:assertlist_cleanup} defaults to unformatted columns. 
When {cmd:format} is specified the file will be formatted with text, color and width options making the spreadsheet easy for the user to read. 
This enables the user to run Stata faster and avoid potential Excel formatting errors due to large spreadsheets. {p_end}

{pmore2} {bf:NOTE: If a tab was already formatted during the {help assertlist} run this formatting will not be undone. If not specified this option only ensures that this run will not add any formatting to the spreadsheet.} {p_end}

{title: Column Name Change Details}
{pstd} The list below enumerates the column name changes that are completed by {cmd:ASSERTLIST_CLEANUP}. All other column names remain the same. {p_end}

{dlgtab:Assertlist_Summary Tab}

{pmore}	{bf:{cmd:ASSERTLIST} Original Column Name}     --->     {it:{cmd:ASSERTLIST_CLEANUP} New Column Name} {p_end}

{pmore2} 1. {bf:_al_sequence_number}:	--->	{it: Assertion Completed Sequence Number} {p_end}
{pmore2} 2. {bf:_al_assertion_syntax}:	--->	{it: Assertion Syntax That Failed} {p_end}
{pmore2} 3. {bf:_al_tag}:	--->	{it:User Specified Additional Information (if any)} {p_end}
{pmore2} 4. {bf:_al_total}:	--->	{it: Total Number of Observations Included in Assertion} {p_end}
{pmore2} 5. {bf:_al_number_passed}:	--->	{it: Number That Passed Assertion.} {p_end}
{pmore2} 6. {bf:_al_number_failed}:	--->	{it:Number That Failed Assertion} {p_end}
{pmore2} 7. {bf:_al_note}:	--->	{it: Note} {p_end}
{pmore2} 8. {bf:_al_sheet}:	--->	{it: Sheet Name That Contains Assertion Output} {p_end}
{pmore2} 9. {bf:_al_idlist}:	--->	{it: Variables Provided in IDLIST Option} {p_end}
{pmore2} 10. {bf:_al_list}:	--->	{it: Variables Provided in LIST Option} {p_end}
{pmore2} 11. {bf:_al_checklist}:	--->	{it: Variables Provided in CHECKLIST Option} {p_end}

{pmore} Reference {help assertlist##assertlist_summary:ASSERTLIST_SUMMARY} for column value details. {p_end}

{dlgtab:Non-Fix Tabs}

{pmore}	{bf:{cmd:ASSERTLIST} Original Column Name}     --->     {it:{cmd:ASSERTLIST_CLEANUP} New Column Name} {p_end}

{pmore2} 1. {bf:_al_sequence_number}:	--->	{it: Assertion Completed Sequence Number} {p_end}
{pmore2} 2. {bf:_al_assertion_syntax}:	--->	{it: Assertion Syntax That Failed} {p_end}
{pmore2} 3. {bf:_al_tag}:	--->	{it:User Specified Additional Information (if any)} {p_end}
{pmore2} 4. {bf:_al_obs_number}:	--->	{it:Observation Number in Dataset} 

{pmore} Reference {help assertlist##sheet:SHEET} for column value details. {p_end}

{dlgtab:FIX tabs}

{pmore}	{bf:{cmd:ASSERTLIST} Original Column Name}     --->     {it:{cmd:ASSERTLIST_CLEANUP} New Column Name} {p_end}

{pmore2} 1. {bf:_al_sequence_number}:	--->	{it: Assertion Completed Sequence Number} {p_end}
{pmore2} 2. {bf:_al_num_var_checked}:	--->	{it:Number of Variables Checked in Assertion} {p_end}
{pmore2} 3. {bf:_al_assertion_syntax}:	--->	{it: Assertion Syntax That Failed} {p_end}
{pmore2} 4. {bf:_al_tag}:		--->	{it:User Specified Additional Information (if any)} {p_end}
{pmore2} 5. {bf:for each variable in {help assertlist##checklist:CHECKlist}:} {p_end}
{pmore2} {bf:NOTE:# will be 1 up to `_al_num_var_checked' for that assertion}{p_end}
{pmore3} a. {bf:_al_var_#}:		--->	{it:Name of Variable # Checked in Assertion} {p_end}
{pmore3} b. {bf:_al_var_type_#}:	--->	{it:Value type of Variable #} {p_end}
{pmore3} c. {bf:_al_original_var_#}:	--->	{it:Current Value of Variable #} {p_end}
{pmore3} d. {bf:_al_correct_var_#}:	--->	{it:Blank Space for User to Provide Correct Value of Variable #} {p_end}
          
{pmore} Reference {help assertlist##fix:FIX} for column value details. {p_end}

{dlgtab:List of IDs failed assertions tab}

{pmore}	{bf:{cmd:ASSERTLIST} Original Column Name}     --->     {it:{cmd:ASSERTLIST_CLEANUP} New Column Name} {p_end}

{pmore2} 1. {bf:_al_idlist}:	--->	{it: List of Variables Used to Identify Line in Assertion} {p_end}
{pmore2} 2. {bf:_al_number_assertions_failed}:	--->	{it:Number of Assertions Line Failed} {p_end}
{pmore2} 3. {bf:for each number of failed assertions in _al_number_assertions_failed:}{p_end}
{pmore3} a. {bf:_al_assertion_details#}:	--->	{it:Assertion Tag or Syntax for # Failed Assertion} {p_end}

{pmore2} {bf:NOTE: `#' will be 1 up to `_al_number_assertions_failed' for that line}{p_end}
{pmore2} {bf:NOTE: This tab is only present if {help assertlist_export_ids} ran prior to {bf:assertlist_cleanup}}.{p_end}

{pmore} Reference {help assertlist_export_ids} for column value details. {p_end}

{hline}

{title:Authors}
{p}

Mary Kay Trimner & Dale Rhoda, Biostat Global Consulting

Email {browse "mailto:Dale.Rhoda@biostatglobal.com":Dale.Rhoda@biostatglobal.com}

Biostat Global Consulting has also created three additional programs that go along with {cmd:assertlist_cleanup} : 
{pstd} {help assertlist} : Initial program that must be run prior to running {cmd:assertlist_cleanup}. {p_end}
{pmore} {cmd:Assertlist}  List observations that contradict an assert command. {p_end}
{pstd} {help assertlist_export_ids} - Provides a high level overview of results by creating a new excel tab within the assertion spreadsheet. 
				  This tab has a single row for each ID that fail 1 or more assertions with columns showing which assertions they failed. {p_end}
{pmore3}{bf: NOTE:To be run after {cmd:assertlist}/{cmd:assertlist_cleanup}}. {p_end}
{pstd} {help assertlist_replace} - Pulls all populated corrected variable values from fix worksheets within an assertlist spreadsheet and puts them in a .do file as replace statements. {p_end}
{pmore3}{bf: NOTE:To be run after {cmd:assertlist}/{cmd:assertlist_cleanup}}. {p_end}

{title:See Also}
{help assert}
{help assertlist}
{help assertlist_export_ids}
{help assertlist_replace}
