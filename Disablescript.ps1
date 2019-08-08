#Thank them
Write-Host -ForegroundColor white -BackgroundColor red "Thank you for choosing Kareem`'s script. If you are fortunate enough to see this message, connect with me on LinkedIn @Kareem Gordon-Graham. Enjoy."

#verifies that the account is valid in AD
function validateuser($user)
{
    try
    {
        #verify this username is in AD
        $userinAD = Get-ADUser -Identity $user
    }
    catch
    {
        Add-Content -Path 'C:\Temp\DisableOutput.log' -Value $user -NoNewline
        Add-Content -Path 'C:\Temp\DisableOutput.log' -Value ' does not exist in AD.' 
        #had to split into two commands because it refused to accept the variable and the string at once
    }
}

#makes sure that the disable worked
function verifydisable($user)
{
    $enable = (Get-ADUser -Identity $user -Properties *).enabled
    if($enabled -eq $false)
    {
        Add-Content -Path 'C:\Temp\DisableOutput.txt' -Value $user -NoNewline
        Add-Content -Path 'C:\Temp\DisableOutput.txt' -Value ' was disabled .' | timestamp 
    } 
}

#disabled the ad account
function disable($user)
{
    try 
    {
        Disable-ADAccount -Identity $user 
    }
    catch 
    {
        Add-Content -Path 'C:\Temp\DisableOutput.txt' -Value $user -NoNewline
        Add-Content -Path 'C:\Temp\DisableOutput.txt' -Value ' disable failed on ' -NoNewline
        Add-Content -Path 'C:\Temp\DisableOutput.txt' -Value (Get-Date -Format 'dddd MM/dd/yyyy HH:mm') -NoNewline
        Add-Content -Path 'C:\Temp\DisableOutput.txt' -Value ' ran by ' -NoNewline
        Add-Content -Path 'C:\Temp\DisableOutput.txt' -Value $env:UserName
        #had to split into two commands because it refused to accept the variable and the string at once
    }
}

######################################################################################################### Separate functions from main code
# Specify path to the text file with the account names.
$users = Get-Content C:\Temp\Users.csv

ForEach( $user1 in $users)
{
    $user = $user1.split(",")[2] #selects the c column
    validateuser($user);
    disable($user);
    verifydisable($user);
    
}