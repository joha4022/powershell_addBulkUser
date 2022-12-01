# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from NewUsersFinal.csv in the $ADUsers variable
$ADUsers = Import-Csv #the directory for the csv file will go here

# Define Domain
$DOMAIN = "#insert domain here"

# Define existing groups
$ADGroups = Get-ADGroup -Filter * | Select-Object DistinguishedName, SamAccountName

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $department = $User.department
    $groups = $User.groups
    $name = $User.name
    $displayname = $User.displayname

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$DOMAIN" `
            -Name $name `
            -GivenName $firstname `
            -Surname $lastname `
            -Enabled $True `
            -DisplayName $displayname `
            -Path $OU `
            -Department $department `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) `
            -ChangePasswordAtLogon $True

        # If user is created, show message.
        Write-Host "The user account for $name is created." -ForegroundColor Green

        foreach($group in $groups.Split(';')) {

            # Checks if a group exists in AD
            If ($ADGroups.SamAccountName -contains $group) {
                
                # If the group exists, then add the member to the group
                Add-ADGroupMember -Identity $group -Members $username
                Write-Host "The user $username have been added to $group." -ForegroundColor Green

            } else {
                
                # else write a warning
                Write-Warning "$group does not exist in AD"
            }
        }
    }
}

Read-Host -Prompt "Press Enter to exit"