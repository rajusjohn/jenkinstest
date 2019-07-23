#======================================================================
# Aspect Software
#======================================================================
#@| SYNOPSIS
# |
#-|   Filename: Add-ACCUserAcct
#-|   Version:  1.1
# |
#-|   Purpose:  Creates an Active Directory domain user account and places it in the 'Aspect Customer Care' OU and ACC security group     
#-|            
#-|   Inputs:  Nothing
#-|   Outputs: Needed accounts in 'Aspect Customer Care' and ACC security group
#---------------------------------------------------------------------------------------------------------------------------
#@| REQUIREMENTS / DEPENDENCIES / ASSUMPTIONS
# |
#---------------------------------------------------------------------------------------------------------------------------
#@| REVISION HISTORY
# |
#-|   Date Created/Revised: 08/16/2018  Author/Revisor: Robb Haskins
#-|                         
#-|   Rev Date:    Rev #    (Revisor):       Description:
#-|   1/19/2018    1.1      Robb Haskins     Added header and comments section         
#---------------------------------------------------------------------------------------------------------------------------
#@| TO DOs
# |   - Expand to include other types of user accounts beside new ACC user accounts.
#-|   - Adjust script to be able to create dependency files then remove after script completetion. 


$Domain = (get-addomain).name
$OU = "ou=Aspect Customer Care,ou=Aspect,dc=$Domain,dc=hosted,dc=aspect-cloud,dc=net"
$ADOU = "Ad:\$OU"
$Test = Test-Path $ADOU

If (!$Test) {
    Write-Warning "The required OU for this account does not exist. Please submit a JIRA ticket to Managed Services to have the correct OU and Security Group added."
    Pause
    exit
}

Function Add-ACCAcct {
        $GN = Read-host "Enter first name of new ACC account being created:"
        $SN = Read-Host "Enter last name of new ACC account being created:"
        $DN = $GN+" "+$SN
        #$DNUpper = ($DN.ToUpper())
        $SAN = $GN[0]+$SN
        $SANLower = ($SAN.ToLower())
        $Domain = (get-addomain).name
        $OU = "ou=Aspect Customer Care,ou=Aspect,dc=$Domain,dc=hosted,dc=aspect-cloud,dc=net" 
        $UPN = "$SANLower@$Domain.HOSTED.ASPECT-CLOUD.NET"
        $PW = "AspectSoft12345$"
        $AcctPW = (ConvertTo-SecureString -AsPlainText $PW -Force)
        $Email = $GN+"."+$SN       
                
        New-ADUser -Name $DN -GivenName $GN -Surname $SN -SamAccountName $SANLower -UserPrincipalName $UPN -AccountPassword $AcctPW `
            -Path $OU -DisplayName $DN -ChangePasswordAtLogon $false -CannotChangePassword $false -PasswordNeverExpires $false -Enabled $true `
            -Description "Aspect Customer Care" -EmailAddress "$Email@aspect.com"

        Add-ADGroupMember -Identity ACC -Members $SANLower

        Write-Host "New ACC user account has been created..." -ForegroundColor Green
        }
             
Add-ACCAcct
$X = Read-Host "Do you want to add another ACC user account? [Y] [N]"

while ($X -ne "N") {
    switch ($X) {
        Y {Write-Host ""
            Add-ACCAcct
            $X = Read-Host "Do you want to add another ACC user account? [Y] [N]"}
    }
}

Write-Host ""
Write-Host "Users created this session..." -ForegroundColor Green
$When = (Get-Date).AddMinutes(-10)
Get-ADUser -Filter {whenCreated -ge $When} -Properties * | select Displayname,SamAccountName,EmailAddress,UserPrincipalName | Out-Host

Pause
