Add-Type -Assembly System.Windows.Forms

function howlong #calculates how long before password expires
{
    $FromDate  = Read-Host 'Enter todays date in mm/dd/yyy format'
    $FromDate1  = [DateTime] $FromDate

    $ToDate  = Read-Host 'Enter the expiration date in mm/dd/yyy format'
    $ToDate1  = [DateTime] $ToDate

    Write-Host ($ToDate1 - $FromDate1).TotalDays ' days until expired.'
}

function infobuttonn #the action behind the update info button
{
                $Info_Form = New-Object System.Windows.Forms.Form
                $Info_Form.Width = 215
                $Info_Form.Height = 150

                $LabelInfoUser = New-Object System.Windows.Forms.Label
                $LabelInfoUser.Text = "Enter Username"
                $LabelInfoUser.Location = New-Object System.Drawing.Point(5,5)

                $LabelInfoUser.AutoSize = $true
                $Info_Form.Controls.Add($LabelInfoUser)

                $TxtBoxUser = New-Object System.Windows.Forms.TextBox
                $TxtBoxUser.Size = New-Object System.Drawing.Size(100,25)
                $TxtBoxUser.Location = New-Object System.Drawing.Point(95,2)
                $Info_Form.Controls.Add($TxtBoxUser)

                $LabelInfoPC = New-Object System.Windows.Forms.Label 
                $LabelInfoPC.Text = "Enter PC Name"
                $LabelInfoPC.Location = New-Object System.Drawing.Point(5,35)
                $LabelInfoPC.AutoSize = $true
                $Info_Form.Controls.Add($LabelInfoPC)

                $TxtBoxPC = New-Object System.Windows.Forms.TextBox
                $PCName = $TxtBoxPC.Text
                $TxtBoxPC.Size = New-Object System.Drawing.Size(100,25)
                $TxtBoxPC.Location = New-Object System.Drawing.Point(95,32)
                $Info_Form.Controls.Add($TxtBoxPC)

                $OKButtonInfo = New-Object System.Windows.Forms.Button
                $OKButtonInfo.Text = "OK"
                $OKButtonInfo.Location = New-Object System.Drawing.Size(60,70)
                $OKButtonInfo.Add_Click{$Info_Form.Close()}
                $OKButtonInfo.Add_Click{nameChange;}#after the window has been created this function handles the update of the username and pc variables
                $Info_Form.Controls.Add($OKButtonInfo)
                $Info_Form.ShowDialog()
}

function nameChange
{
        $Global:Username = $TxtBoxUser.text
        $Global:PCname = $TxtBoxPC.text
        Get-ADUser $Global:Username 
        $PCName = $TxtBoxPC.Text
        ##User Username and PCName Information
        $LabelUser = New-Object System.Windows.Forms.Label
        $LabelUser.Text = "UserInformation:"
        $LabelUser.Location  = New-Object System.Drawing.Point(260,12)
        $LabelUser.AutoSize = $true
        $Main_form.Controls.Add($LabelUser)

        $MainTxtBox = New-Object System.Windows.Forms.TextBox #spawn new info box
        $MainTxtBox.Location  = New-Object System.Drawing.Point(260,30)
        $MainTxtBox.Size  = New-Object System.Drawing.Size(100,60)
        $MainTxtBox.AutoSize = $false
        $MainTxtBox.Multiline = $true
        $MainTxtBox.BackColor = "Azure"

        $MainTxtBox.AppendText("User Name: `r`n$Global:Username `r`nPC Name: `r`n$PCName")#fill the new box with the entered credentials
        $MainTxtBox.Focus()
        $Main_form.Controls.Add($MainTxtBox)
        $MainTxtBox.BringToFront() #brings the new window with the new info to the front so you never see the old window
         $Main_Form.Show()   
}
  function startt
{
        #serves as the creator of the original window the gui starts off with
        ##User Username and PCName Information
        $LabelUser = New-Object System.Windows.Forms.Label
        $LabelUser.Text = "UserInformation:"
        $LabelUser.Location  = New-Object System.Drawing.Point(260,12)
        $LabelUser.AutoSize = $true
        $Main_form.Controls.Add($LabelUser)

        $MainTxtBox = New-Object System.Windows.Forms.TextBox
        $MainTxtBox.Location  = New-Object System.Drawing.Point(260,30)
        $MainTxtBox.Size  = New-Object System.Drawing.Size(100,60)
        $MainTxtBox.AutoSize = $false
        $MainTxtBox.Multiline = $true
        $MainTxtBox.BackColor = "Azure"
        
        $MainTxtBox.AppendText("User Name: `r`n$Global:Username `r`nPC Name: `r`n$PCName")#does not effect after ther change
          
        $MainTxtBox.Enabled = $false
        $Main_form.Controls.Add($MainTxtBox)
}   
function InfoButton
{
        $InfoButton = New-Object System.Windows.Forms.Button
        $InfoButton.Text = "Update Information"
        $InfoButton.Location = New-Object System.Drawing.point(260,90)
        $InfoButton.Size = New-Object System.Drawing.Size(100,30)
        $Main_Form.Controls.Add($InfoButton)

            $InfoButton.Add_Click(
            {
                infobuttonn;#running the action  
            })      
}
function dnsCache
{        
        ##Clears DNS Cache
        $ButtonDNS = New-Object System.Windows.Forms.Button
        $ButtonDNS.Text = "Flush Local DNS"
        $ButtonDNS.Size = New-Object System.Drawing.Size(120,23)
        $ButtonDNS.Location = New-Object System.Drawing.Size(5,30)
        $Main_Form.Controls.Add($ButtonDNS)
        
            $ButtonDNS.Add_Click(
            {
                #Start me as a job and give Prompt when job is finsihed
                Clear-DnsClientCache
                $DNS_Form = New-Object System.Windows.Forms.Form

                $DNS_Form.Width = 205
                $DNS_Form.Height = 150

                $DNSLabel = New-Object System.Windows.Forms.Label
                $DNSLabel.Text = "Your DNS Cache has been cleared."
                $DNSLabel.Location  = New-Object System.Drawing.Point(5,5)
                $DNSLabel.AutoSize = $true
                $DNS_Form.Controls.Add($DNSLabel)

                $OKButtonDNS = New-Object System.Windows.Forms.Button
                $OKButtonDNS.Text = "OK"
                #Set me to only open within the main form window
                $OKButtonDNS.Location = New-Object System.Drawing.Size(60,50)
                $OKButtonDNS.Add_Click{$DNS_Form.Close()}
                $OKButtonDNS.Add_Click{$Main_Form.Refresh()}
                $DNS_Form.Controls.Add($OKButtonDNS)
                $DNS_Form.ShowDialog()

            })
}
function NetUserDomain
{
        #$forname = ($Global:Username).ToString()
        ##Pulls Net UserDomain information
        $ButtonNUD = New-Object System.Windows.Forms.Button
        $ButtonNUD.Text = 'Password Expiration'
        $ButtonNUD.Size = New-Object System.Drawing.Size(120,23)
        $ButtonNUD.Location = New-Object System.Drawing.Size(5,60)
        $Main_Form.Controls.Add($ButtonNUD)
            
            $ButtonNUD.Add_Click(
            {
                $NUD_Form = New-Object System.Windows.Forms.Form

                $NUD_Form.Width = 450
                $NUD_Form.Height = 550

                $NUDLabel = New-Object System.Windows.Forms.Label
                $NUDLabelText =  $NUDLabelText = net user /domain $Global:Username | Out-String
                $NUDLabel.Text = $NUDLabelText
                $NUDLabel.Size = New-Object System.Drawing.Size(600,600)
                $NUD_Form.Controls.Add($NUDLabel)
                $NUD_Form.ShowDialog()
                $ans = Read-Host 'Would you laike to know the days until password expiration?'
                if($ans -eq 'Yes')
                {
                    howlong;
                }
            })
}
function Pingfunc
{
        ##Performs Ping Function
        $ButtonPing = New-Object System.Windows.Forms.Button
        $ButtonPing.Text = 'Ping PC'
        $ButtonPing.Size = New-Object System.Drawing.Size(120,23)
        $ButtonPing.Location = New-Object System.Drawing.Size(5,90)
        $Main_Form.Controls.Add($ButtonPing)

            $ButtonPing.Add_Click(
            {
                $Ping_Form = New-Object System.Windows.Forms.Form

                $Ping_Form.Width = 500
                $Ping_Form.Height = 150

                $PingLabel = New-Object System.Windows.Forms.Label
                $PingLabelText = Test-Connection -ComputerName "$Global:PCName" | Out-String
                $PingLabel.Text = $PingLabelText
                $PingLabel.Size = New-Object System.Drawing.Size(600,600)
                $Ping_Form.Controls.Add($PingLabel)
                $Ping_Form.ShowDialog()
            })
}
function RemoteOptions
{
        
        #Provides 3 Remote options
        $ButtonRemote = New-Object System.Windows.Forms.Button
        $ButtonRemote.Text = 'Remote Options'
        $ButtonRemote.Size = New-Object System.Drawing.Size(120,23)
        $ButtonRemote.Location = New-Object System.Drawing.Size(5,120)
        $Main_Form.Controls.Add($ButtonRemote)

            $ButtonRemote.Add_Click(
            {
                $Remote_Form = New-Object System.Windows.Forms.Form

                $Remote_Form.Width = 410
                $Remote_Form.Height = 75

                $Button_RDP = New-Object System.Windows.Forms.Button
                $Button_RDP.Text = 'Remote Desktop'
                $Button_RDP.Size = New-Object System.Drawing.Size(120,23)
                $Button_RDP.Location = New-Object System.Drawing.Size(5,5)
                $Remote_Form.Controls.Add($Button_RDP)
                    $Button_RDP.Add_Click(
                    {
                        mstsc /v:$Global:PCName
                    })

                $Button_RA = New-Object System.Windows.Forms.Button
                $Button_RA.Text = 'Remote Assist'
                $Button_RA.Size = New-Object System.Drawing.Size(120,23)
                $Button_RA.Location = New-Object System.Drawing.Size(135,5)
                $Remote_Form.Controls.Add($Button_RA)
                    $Button_RA.Add_Click(
                    {
                        msra /offerra $Global:PCName    
                    })

                $Button_JMSRA = New-Object System.Windows.Forms.Button
                $Button_JMSRA.Text = 'JMS Remote Assist'
                $Button_JMSRA.Size = New-Object System.Drawing.Size(120,23)
                $Button_JMSRA.Location = New-Object System.Drawing.Size(265,5)
                $Remote_Form.Controls.Add($Button_JMSRA)
                    $Button_JMSRA.Add_Click(
                    {
                        $JMSRAPath = Test-Path "C:\Program Files\JMSSupport\JmsRemoteAssistanceHelpDesk\jmsRemoteAssistanceHelpDesk.exe"
                        IF ($JMSRAPath -eq "True")
                            {
                                Start-Process "C:\Program Files\JMSSupport\JmsRemoteAssistanceHelpDesk\jmsRemoteAssistanceHelpDesk.exe"
                            }
                        ELSE
                            {
                                $JMSRA_Form = New-Object System.Windows.Forms.Form

                                $JMSRA_Form.Width = 300
                                $JMSRA_Form.Height = 100

                                $JMSRALabel = New-Object System.Windows.Forms.Label
                                $JMSRALabel.Size = New-Object System.Drawing.Size(600,600)
                                $JSMRALabel.Location = (5,5)
                                $JMSRALabel.Text = "Please install the JMS Remote Assistance Tool `n and relaunch the program."
                                $JMSRA_Form.Controls.Add($JMSRALabel)
                                $JMSRA_Form.ShowDialog() 
                            }    
                    })

            $Remote_Form.ShowDialog()
            })
        
        ##
        $ButtonPassReset = New-Object System.Windows.Forms.Button
        $ButtonPassReset.Text = 'Password Reset'
        $ButtonPassReset.Size = New-Object System.Drawing.Size(120,23)
        $ButtonPassReset.Location = New-Object System.Drawing.Size(5,150)
        $Main_Form.Controls.Add($ButtonPassReset)

        ##Big Heart Jump Box
        $ButtonBH = New-Object System.Windows.Forms.Button
        $ButtonBH.Text = 'Big Heart Jumpbox'
        $ButtonBH.Size = New-Object System.Drawing.Size(120,23)
        $ButtonBH.Location = New-Object System.Drawing.Size(5,180)
        $Main_Form.Controls.Add($ButtonBH)
            $ButtonBH.Add_Click(
            {
                mstsc /v:"spghjmsjump01" 
            })

        ##
        $ButtonDomain = New-Object System.Windows.Forms.Button
        $ButtonDomain.Text = 'Change Domain'
        $ButtonDomain.Size = New-Object System.Drawing.Size(120,23)
        $ButtonDomain.Location = New-Object System.Drawing.Size(5,210)
        $Main_Form.Controls.Add($ButtonDomain)

        ##
        $ButtonHDrive = New-Object System.Windows.Forms.Button
        $ButtonHDrive.Text = 'Create H-Drive'
        $ButtonHDrive.Size = New-Object System.Drawing.Size(120,23)
        $ButtonHDrive.Location = New-Object System.Drawing.Size(5,240)
        $Main_Form.Controls.Add($ButtonHDrive)
        
        ##
        $ButtonLock = New-Object System.Windows.Forms.Button
        $ButtonLock.Text = 'Who Locked Me'
        $ButtonLock.Size = New-Object System.Drawing.Size(120,23)
        $ButtonLock.Location = New-Object System.Drawing.Size(5,270)
        $Main_Form.Controls.Add($ButtonLock)

        ##Opens up C$ on entered PC Name
        $ButtonC = New-Object System.Windows.Forms.Button
        $ButtonC.Text = 'C$ to PC'
        $ButtonC.Size = New-Object System.Drawing.Size(120,23)
        $ButtonC.Location = New-Object System.Drawing.Size(5,300)
        $Main_Form.Controls.Add($ButtonC)
            $ButtonC.Add_Click(
            {
                $Connection = Test-Path -Path "\\$Global:PCName\c$"
                IF($Connection = $False)
                    {
                        $C_Form = New-Object System.Windows.Forms.Form

                        $C_Form.Width = 312
                        $C_Form.Height = 100

                        $CLabel = New-Object System.Windows.Forms.Label
                        $CLabel.Text = "PC Can not be reached. Please verify connection and retry."
                        $CLabel.AutoSize = $True
                        $C_Form.Controls.Add($CLabel)

                        $OKButtonC = New-Object System.Windows.Forms.Button
                        $OKButtonC.Text = "OK"
                        $OKButtonC.Location = New-Object System.Drawing.Size(115,25)
                        $OKButtonC.Add_Click{$C_Form.Close()}
                        $C_Form.Controls.Add($OKButtonC)
                        $C_Form.ShowDialog()
                    }
                ELSE
                    {
                       ii "\\$Global:PCName\c$"
                    }
            }) 
    $Main_Form.ShowDialog()
    
}
    ###############################everything ran is under this line
    
     #TempInfo
        $global:Username = "Cgross1"
        $global:PCName = "orrws00821"
        ##Presents main form
        $Global:Main_Form = New-Object System.Windows.Forms.Form
        $Main_Form.Text = "JMS QuickDesk"
        $Main_Form.Width = 400
        $Main_Form.Height = 400
        $Main_Form.AutoSize = "True"
        $Main_Form.BackColor = "Cyan"
        #$Main_Form.Icon = "CHANGE ME"

        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = "Select Options:"
        $Label.Location  = New-Object System.Drawing.Point(5,10)
        $Label.AutoSize = $true
        $Main_form.Controls.Add($Label)
        
       startt;
       InfoButton;
       dnsCache;
       NetUserDomain
       Pingfunc;
       RemoteOptions;