#VARS for one-stop results
$BASNUM = 0;
$PITTITNUM = 0;
$REMOTENUM = 0;
$REMOTEWORKWINDOWSNUM = 0;
$PITTITWVNUM = 0;
$PITTITHINUM = 0;
$SSOEVIRNUM = 0;

$AZWMod = Get-Module -Name Az.DesktopVirtualization
$AZAResourcesMod = Get-Module -Name Az.Resources

#NOC pools to test, just add additional pools by the "name" field in single (') quotes with commas (,) separating, in the order of the report in the turnover, top to bottom
$Tests = 'BAS-AVD-POOL','PittIT-Student-Virtual-Computing-Lab','REmote-Work-Pool','Remote-Work-Pool-WIndows11','PITTIT','PITTIT-HI','SSO2021-2022'

#Module installation if needed
If ($AZWVDMod -eq $null) {
    
    Install-Module -Name Az.DesktopVirtualization
}
If ($AZAZResourcesModule -eq $null) {
    
    Install-Module -Name Az.Resources
}

#Connects Azure account if not connected
If ($connect -eq $null){
    
    $connect = Connect-AzAccount
}

$SetSub = Get-AzSubscription -SubscriptionName "Azure Production Environment" | Set-AzContext
$AllSess = 0
$AllDrain = 0
$AvailHosts = 0

#Stores choice for detailed report
$ShortOption = Read-Host "Would you like a fully detailed report? (Y/N)"

#Is it the users first report request
$FirstPass = $true

#Runs automatically reporting data at the top and middle of the hour
while($true) 
{
    $currTime = (get-date).ToString("mm:ss")

    if($FirstPass -or ($currTime -eq "00:00") -or ($currTime -eq "30:00"))
    {
        #Runs script for each Pool defined in $Tests above
        for ( $index = 0; $index -lt $Tests.count; $index++) {

        $Hostpool = $Tests[$index]

        $RG = Get-AzResource -Name $Hostpool

        #Check Sessions and RDP
        $Hosts = Get-AzWvdSessionHost -HostPoolName $Hostpool -ResourceGroupName $RG.ResourceGroupName | Where-Object Status -CEQ "Available"
        $AvailHosts = $Hosts.Count

        #Var for current host
        $Currenthost = $Hostpool

        #Processes current host and stores number of available hosts
        Switch ($Currenthost)
        {
            BAS-AVD-POOL{$BASAVDNUM = $AvailHosts }
            PittIT-Student-Virtual-Computing-Lab{$PITTITVINUM = $AvailHosts}
            REmote-Work-Pool{$REMOTENUM = $AvailHosts}
            Remote-Work-Pool-WIndows11{$REMOTEWORKWNUM = $AvailHosts}
            PITTIT_WVD{$PITTITWVNUM = $AvailHosts}
            PITTIT-HIPAA-FZ{$PITTITHIPNUM = $AvailHosts}
            SSOE-Virtual-Lab-2021-2022{$SSOEVIRNUM = $AvailHosts}
        }


            If($ShortOption -eq 'Y')
            {
                foreach ($vm in $Hosts) {
                    $RDPTest = $null
                    #If ($vm.status -ceq "Available") {
                        $HN = ($vm.Name).Split('/')
                        Write-Host "Sessions on" $HN[1]
                        Get-AzWvdUserSession -HostPoolName $Hostpool -ResourceGroupName $RG.ResourceGroupName -SessionHostName $HN[1] | Select -ExpandProperty UserPrincipalName
                        $TS = Get-AzWvdUserSession -HostPoolName $Hostpool -ResourceGroupName $RG.ResourceGroupName -SessionHostName $HN[1] | Select -ExpandProperty UserPrincipalName
                        Write-Host "Total Active Sessions" $TS.Count `n
                        $AllSess = $AllSess + $TS.Count 
                        $DCSess = Get-AzWvdUserSession -HostPoolName $Hostpool -ResourceGroupName $RG.ResourceGroupName -SessionHostName $HN[1] | Where-Object {$_.SessionState -ceq "Disconnected"}
  
                        If ($DCSess.Count -gt 0) {
                            #Write-Host "Disconnected Users" $DCSess.count `n -ForegroundColor Red
                            If ($DCSess.Count -eq $TS.Count) {
                                Write-Host "Disconnected Sessions" $DCSess.Count" is equal to Total Sessions" $TS.count".  There may be an issue.  Red is more than 20 minutes old, Green is less than 20 minutes." `n -ForegroundColor Magenta
                            }
                            Write-Host "Checking how old Disconnected Sessions are on"$HN[1]"...." `n -ForegroundColor Magenta
                            foreach ($DCTime in $DCSess)  {
                                $targettz = [System.TimeZoneInfo]::FindSystemTimeZoneById('Eastern Standard Time')
                                $DCESTTme = [System.TimeZoneInfo]::ConvertTime($DCTime.CreateTime,$targettz)
                                $DCUser = $DCTime.UserPrincipalName
                                If ($DCESTTme -lt ((Get-Date).AddMinutes(-20))) {
                                    Write-Host "GREATER THAN 20 MINUTES -" $DCESTTme" - "$DCUser  -ForegroundColor Red            
                                }else{
                                    Write-Host "LESS THAN 20 MINUTES -" $DCESTTme" - "$DCUser -ForegroundColor Green
                                }    
                            }
                            Write-Host `n
                    }
                #This section tells the script to RDP        
                #    If ($TS.Count -lt 1) {
                #        $RDPTest = New-Object System.Net.Sockets.TCPClient -ArgumentList $HN[1],3389
                #        Write-Host "RDP Test on"$HN[1]" - Connected ="$RDPTest.Connected `n
                #    }
                }

                If ($VM.AllowNewSession -eq $false) {
                    Write-Host $HN[1]"is currently in Drain Mode" `n -ForegroundColor Red
                    $AllDrain = $AllDrain + 1
                    }

                Write-Host "Total Hosts Available in Hostpool "$Hostpool" = "$AvailHosts -ForegroundColor Yellow
                Write-Host "Total Sessions in HostPool "$Hostpool" =" $AllSess -ForegroundColor Yellow
                Write-Host "Total Machines in Drain Mode ="$AllDrain -ForegroundColor Yellow
                Write-Host ' '
                Write-Host "-------------------------------------------------------------------------" -ForegroundColor White -BackgroundColor Blue 
                Write-Host ' '
             }
        }

        #Printing results
        Write-host "Total Hosts Available in Hostpool "BAS-AVD-POOL" = "$BASAVDPOOLNUM -ForegroundColor Yellow
        Write-host "Total Hosts Available in Hostpool "PittIT-Student-Virtual-Computing-Lab" = "$PITTITVIRLABNUM -ForegroundColor Yellow
        Write-host "Total Hosts Available in Hostpool "REmote-Work-Pool" = "$REMOTEWORKNUM -ForegroundColor Yellow
        Write-host "Total Hosts Available in Hostpool "Remote-Work-Pool-WIndows11" = "$REMOTEWORKWINDOWS11NUM -ForegroundColor Yellow
        Write-host "Total Hosts Available in Hostpool "PITTIT_WVD" = "$PITTITWVDNUM -ForegroundColor Yellow
        Write-host "Total Hosts Available in Hostpool "PITTIT-HIPAA-FZ" = "$PITTITHIPAAFZNUM -ForegroundColor Yellow
        Write-host "Total Hosts Available in Hostpool "SSOE-Virtual-Lab-2021-2022" = "$SSOEVINUM -ForegroundColor Yellow
        Get-date 

        Write-Host "Press CTRL+C to exit to the command line" -ForegroundColor White -BackgroundColor Red
        $FirstPass = $false
        }
}
