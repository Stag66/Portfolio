#Thank them
Write-Host -ForegroundColor white -BackgroundColor red "Thank you for choosing Kareem`'s script. If you are fortunate enough to see this message, connect with me on LinkedIn @Kareem Gordon-Graham. Enjoy."  

#checks to see if the account is unlocked then proceeds to unlock the account and, if the user elects, unlocks the password
function checklockdoresets
{
    #check if the account is locked
    $isacctlocked = get-aduser -Identity $userinAD -Properties lockedout 
    $reallyisacctlocked = $isacctlocked.lockedout #hone in on the boolean value
    if($reallyisacctlocked -eq $false)
    {
        Write-Host 'The account is not locked. Seems like there is another problem. Have a great day!'
        main;#return to initial prompt
    }  
    else
    {
        #get their DC
        $userDC = (get-aduser $username -Properties Description).description
        #get the three letters that represent their dc
        $actualDC = $userDC.split(".")[0]
        #run the unlock. if that doesn't work, prompt for password unlock.
        domcontrollers($actualDC);
    }
}

function takeandvalidateusername
{
    #get username
    $username = Read-Host 'Please enter the customers username'
    try
    {
        #verify this username is in AD
        $userinAD = Get-ADUser -Identity $username
    }
    catch
    {
        Write-Host 'Username does not exist in AD. Try again.'
        main;#return to initial prompt
    }
}

#procedure for prompting for a password reset 
function doyouwantapwordreset($DC)
{
        $werewesuccessful = Read-Host 'Did the unlock work? Yes or No.'
        if($werewesuccessful -eq 'Yes')
        {
            Write-Host 'Thank you for using this script! Have a great day!'
            main;#return to initial prompt
        }
        else
        {
             
            $pwordreset = Read-Host 'Sorry that didnt work. Would you like to do a password reset?'
            if($pwordreset -eq 'Yes')
            {       #spawning the outlook application
                    $wshell = New-Object -ComObject Wscript.Shell
                    $wshell.Popup("WARNING! Company policy states that you may not state the new password over the phone! You MUST email the new password via company emails.",0,"Done",0x1)
                
                    if($DC -eq 'orr')
                    {
                        resetpword('orrlathj');#if the DC is orr run the reset from the orr servers
                    }
                    else
                    {
                        resetpword($DC);
                    }

                    #Prepare the email to send. You will have to input the new password and user email manually
                    $Outlook = New-Object -ComObject Outlook.Application
                    $Mail = $Outlook.CreateItem(0)
                    $Mail.To = "random.dude@jmsmucker.com"
                    $Mail.Subject = "New Password"
                    $Mail.Body = "Enter new password here"
                    $mail.save()
                    $inspector = $mail.GetInspector
                    $inspector.Display()
                
                    Write-Host 'Have a great day!'
                    main;#return to initial prompt
  
            }
            else
            {
                Write-Host 'Sorry for the inconvenience. Bye!' 
                main;#return to initial prompt
            }
        }
}

#procedure for resetting passwords 
function resetpword($actualDC1)
{
    $SecPaswd = Read-Host 'Please enter the new password.'
    $SecPaswd2 = ConvertTo-SecureString -AsPlainText $SecPaswd #account passwords must be secure strings
    Set-ADAccountPassword -Reset -NewPassword $SecPaswd2 –Identity $userinAD -Server $actualDC1
}

#procedure for unlocking on defined non-orrvile domain controllers
function nonorrvilledomcontroller($actualDC1)
{
    $endPart = 'msrvg'
    $diffDC = $actualDC1 + $endPart #combine the three letters with their endings
    Unlock-ADAccount -Identity $userinAD -Server $diffDC
    Write-Host 'Account has been unlocked on' + $diffDC + ' server'
    return $diffDC #returns the completed domain controller name that will be used as the servername in the password reset function
}

#figures out the domain controller of the customer then runs an account unlock from that server. 
#if that is unsuccessful, it prompts for a password reset. 
#orrville domain controllers and domain controllers that differ from the expected non-orrville domain controllers 
#run the unlock and password reset from orr servers 
#the password function uses the returned domain controller name from the domcontroller function since we need the three letters plus msrvg combined in one name. found it once no need to find it twice REUSE
function domcontrollers($actualDC1)
{
     switch($actualDC1)
     {
        "orr" 
        { Unlock-ADAccount -Identity $userinAD -Server orrlathj
          Write-Host 'Account has been unlocked on' + $actualDC1 + ' server.'
          doyouwantapwordreset('orr'); }
        "ben"
        { doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "blm"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));;}
        "buf"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "chf"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "chi"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "cin"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "clt"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "dec"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "fro"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "gdv"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "gnt"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "hdg"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "lac"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "law"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "lex"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "lmt"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "mar"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "mea"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "mem"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "mia"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "min"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "nbe"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "oxn"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "rip"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "sct"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "sea"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "shb"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "sil"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "suf"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "tam"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "lmt"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "tol"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "top"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "mem"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "mia"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "min"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "nbe"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "oxn"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        "rip"
        {doyouwantapwordreset(nonorrvilledomcontroller($actualDC1));}
        default 
        {Unlock-ADAccount -Identity $userinAD -Server orrlathj
         Write-Host 'Account has been unlocked on orr server.' 
         doyouwantapwordreset('orr');} #send unknown/undefined/unused domain controllers through orrville
     }
} 

#where all the other functions combine to complete the unlock task. 
#small but must be a function so we can keep looping
function main 
{
    takeandvalidateusername;

    checklockdoresets;
}
####################################################################################################### separates function definitions from the main code
main;#run