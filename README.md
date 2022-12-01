# powershell_addBulkUser
.xlsx and .ps1 file to add bulk users to active directory

For excel sheet:
1. Insert Firstname, Lastname, and Rank only in proper format for uniformity.
2. Once all the Firstname, Lastname, and Rank have been filled highlight the first row with equations and drag it down to the last name inserted.
3. Export it as .CSV file.
4. OU needs which OU the users want to be located in
5. Groups will be divided by ";" with no spaces. Example: Group 1;Group2

For PowerShell:
1. Open the .ps1 file in PowerShell ISE
2. Ensure the Import-CSV has proper location of the .csv file
3. Insert the domain of the active directory that the users are getting added to.
4. Run the script.
