# Import active directory module for running AD cmdlets
Import-Module activedirectory
$Domain = (get-addomain).name
$OU = "ou=Managed Services,ou=Aspect,dc=$Domain,dc=hosted,dc=aspect-cloud,dc=net"
$ADUsers = Import-csv  C:\Users\rreddy\Desktop\multi\userslist.csv

foreach ($User in $ADUsers)
{

	
	$Password 	= $User.password
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
    $Username   = $Firstname[0]+$Lastname

if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user does exist, give a warning
	Write-Warning "A user account with username $Username already exist in Active Directory."
	Set-ADAccountPassword -Identity $Username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
    Add-ADGroupMember -Identity Administrators -Members $Username
    Set-ADUser -Identity $Username -PasswordNeverExpires $false -Enabled $false
    Unlock-ADAccount -Identity $Username
    Set-ADUser -Identity $Username -Enabled $true
   	Write-Host "We reseted password for $Username" -ForegroundColor Green
   		
    }
	else
	{
Function Add-NOCAcct {
        $GN = $Firstname
        $SN = $Lastname
        $DN = $GN+" "+$SN
        #$DNUpper = ($DN.ToUpper())
        $SAN = $GN[0]+$SN
        $SANLower = ($SAN.ToLower())
        $Domain = (get-addomain).name
        $OU = "ou=Managed Services,ou=Aspect,dc=$Domain,dc=hosted,dc=aspect-cloud,dc=net" 
        $UPN = "$SANLower@$Domain.HOSTED.ASPECT-CLOUD.NET"
        $PW = $Password
        $AcctPW = (ConvertTo-SecureString -AsPlainText $PW -Force)
        $Email = $GN+"."+$SN       
                
        New-ADUser -Name $DN -GivenName $GN -Surname $SN -SamAccountName $SANLower -UserPrincipalName $UPN -AccountPassword $AcctPW `
            -Path $OU -DisplayName $DN -ChangePasswordAtLogon $false -CannotChangePassword $false -PasswordNeverExpires $false -Enabled $false `
            -Description "NOC" -EmailAddress "$Email@aspect.com"

        Add-ADGroupMember -Identity NOC -Members $SANLower
	Add-ADGroupMember -Identity Administrators -Members $Username

Write-Host "New NOC user account has been created..." -ForegroundColor Green
Write-Host ""
Write-Host "Users created this session..." -ForegroundColor Green
$When = (Get-Date).AddMinutes(-10)
Get-ADUser -Filter {whenCreated -ge $When} -Properties * | select Displayname,SamAccountName,EmailAddress,UserPrincipalName | Out-Host

        }
        
             
Add-NOCAcct
}}

#Pause

