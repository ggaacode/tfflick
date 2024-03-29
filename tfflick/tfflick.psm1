﻿Function tfflick {
    Param(
        [Parameter(Mandatory=$false, Position=0, HelpMessage="Argument to make a decision")][string] $argument,
        [Parameter(Mandatory=$false, HelpMessage="Help menu argument")][switch] $h
    )

try {
    # Set -h argument to present help options menu
    if ($h) {$argument = "help"}  

Function __tfflick_shortmenu (){
      
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions,
        [Parameter(Mandatory=$True)][String]$RowsToDisplay,
        [Parameter(Mandatory=$False)][bool]$ShowCurrentSelection=$False)

$RowsToDisplay = 5
$Start = 0
$End = $RowsToDisplay-1
$Rows = $MenuOptions.count
$Selection = 0
$DownArrow = "↓"
$UpArrow = "↑"
$SelectionArrow = "→"
$EnterPressed = $False

Clear-Host
    
While($EnterPressed -eq $False){    
    
    Write-Host "$MenuTitle"

    If ($ShowCurrentSelection -eq $True){
        $Host.UI.RawUI.WindowTitle = "CURRENT SELECTION: $($MenuOptions[$Selection])"
    }

    for ($i=$Start; $i -le $End; $i++) {
        if ($i -eq $Selection) {
            if ($i -eq $End -and $End -ne $Rows-1) {
                Write-Host -NoNewline -BackgroundColor White -ForegroundColor Black " $SelectionArrow"$MenuOptions[$i]
                Write-Host " "$DownArrow 
            }
            elseif ($i -eq $Start -and $Start -ne 0) {
                Write-Host -NoNewline -BackgroundColor White -ForegroundColor Black " $SelectionArrow"$MenuOptions[$i]
                Write-Host " "$UpArrow
            }
            else {
                Write-Host -BackgroundColor White -ForegroundColor Black " $SelectionArrow"$MenuOptions[$i]
            }
        }
        else
        {
            if ($i -eq $End -and $End -ne $Rows-1) {
                Write-Host -NoNewline "  "$MenuOptions[$i]
                Write-Host " "$DownArrow 
            }
            elseif ($i -eq $Start -and $Start -ne 0) {
                Write-Host -NoNewline "  "$MenuOptions[$i] 
                Write-Host " "$UpArrow               
            }
            else {
                Write-Host "  "$MenuOptions[$i]
            }
        }
    }        
        
    $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

       Switch($KeyInput){
           13{
               $EnterPressed = $True
               Return $Selection          
               Clear-Host
               break
           }           
           38{ #Up
               if ($Selection -gt 0 -and $Selection -le ($Rows-1)) {
                   if ($Selection -eq $End) {
                       $Selection -= 1
                       $Start = $Start
                       $End = $End
                   }
                   elseif($Selection -gt $Start -and $Selection -lt $End) {
                       $Selection -= 1
                       $Start = $Start
                       $End = $End
                   }
                   elseif ($Selection -le $Start) {                   
                       $Selection -= 1
                       $Start -= 1
                       $End -= 1
                   }
               }                          
               Clear-Host
               break
           }

           40{ #Down
               if ($Selection -ge 0 -and $Selection -lt ($Rows-1)) {
                  if ($Selection -eq $Start) {
                   $Selection += 1
                   $Start = $Start
                   $End = $End
                  }
                  elseif($Selection -gt $Start -and $Selection -lt $End) {
                   $Selection += 1
                   $Start = $Start
                   $End = $End
                  }
                  elseif ($Selection -ge $End) {                   
                   $Selection += 1
                   $Start += 1
                   $End += 1
                  }
               }                       
               Clear-Host
               break
           }            
       
           Default{
               Clear-Host
           }
        }
}    
}
#********************** tfflick **********************

# tfflick code starts here  

# Set base URL to Hashicorp releases
$baseurl = "https://releases.hashicorp.com/terraform/"  
    Function __tfflick_worker {    
        Param(
            [Parameter(Mandatory=$True, Position=0, HelpMessage="Argument to make a decision")]$tfw_argument            
        )

        $homedir     = $env:USERPROFILE
        $tfflickpath = $homedir+"\.tfflick"
        $tfversions  = $tfflickpath+"\tfversions"    
        $versionfile = "terraform_"+$tfw_argument+".exe" # Set version format as the file downloads as terraform.exe

        # Set url and zip file format        
        $url =  $baseurl+$tfw_argument+"/terraform_"+$tfw_argument+"_windows_amd64.zip"
        $zipfile = "terraform_"+$tfw_argument+"_windows_amd64.zip"

        # Create tfflick and tfversions working directories to hold all downloaded Terraform versions if it doesn't exist    
        if (-not(Test-Path -Path $tfflickpath)) {
            Write-Host "Creating $tfflickpath\$tfversions directory"
            New-Item $tfflickpath\$tfversions -ItemType Directory
        }       
          
        # Check if file files already exists. If it does, don't download.
        if (Test-Path -Path $tfversions"\"$versionfile) {
           Write-Host "Version $tfw_argument already downloaded"
        }
        elseif ( -not(Test-Path -Path $tfversions"\"$versionfile))
        {
        # Download file if not already in the system
           $ProgressPreference = 'SilentlyContinue' 
           [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12      
           Invoke-WebRequest $url -OutFile $tfflickpath"\"$zipfile
           Write-Host "Downloading version $tfw_argument"
           Expand-Archive $tfflickpath"\"$zipfile -DestinationPath $tfversions -Force
           Rename-Item -Path $tfversions"\terraform.exe" -NewName $versionfile -Force       
           Remove-Item -Path $tfflickpath"\"$zipfile -Force
        }
        # Link terraform.exe to selected version.
        New-Item -ItemType HardLink -Path $tfflickpath -Name terraform.exe -Value $tfversions"\"$versionfile -Force
    }

    if  ( -not($argument)) { # Present full list of versions if no argument is provided
        
        # Retrieve list of available Terraform versions
        $ProgressPreference = 'SilentlyContinue'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $versionslist = Invoke-WebRequest -URI $baseurl
        $list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
        # Create list of options to be presented to user. Format: 1.3.4 - terraform_1.3.4
        $shortversionslist =  $list.outerText | ForEach-Object -Process {$_.Substring("terraform_".Length, $_.Length-"terraform_".Length)}
        
        $Title = " ## tfflick ##`nSelect a Terraform version `nand press enter.`n"
        $Options = $shortversionslist

        $Selection = __tfflick_shortmenu -MenuTitle $Title -MenuOptions $Options -RowsToDisplay 5 -ShowCurrentSelection $True
        Clear-Host
        Write-Host "You selected version " $shortversionslist[$Selection]
        $argument = $shortversionslist[$Selection]
        
        # Call __tfflick_worker function with selected version
        __tfflick_worker -tfw_argument $argument        
    }
    elseif ($argument -match "^[0-9]+.[0-9]+.[0-9]+$") {
        __tfflick_worker -tfw_argument $argument
    }        
    elseif ($argument -eq "help") { # Display tfflick usage options
        $tfflickusage = @'

    ## Usage
    
    * tfflick (no arguments)
            - Returns a menu list of available Terraform versions
            - Use your arrow keys to select the desired version and press enter
    
    * tfflick {version number}
            - Pass the desired version as the argument. For example tfflick 1.3.4 
    
    * tfflick -h or tfflick help
            - Displays tfflick usage options

'@
        
        Write-Host $tfflickusage

        break
    }
    else {
       # Display error message if something goes wrong
       Write-Host "Someting went wrong. Please provide a version number as an argument. For example tfflick 1.3.4"
       Write-Host "To view a full list of available versions try tfflick (with no arguments)"
    }    
}
catch {
    # Display error message if something goes wrong
    Write-Host "Someting went wrong. Please provide a version number as an argument. For example tfflick 1.3.4"
    Write-Host "To view a full list of available versions try tfflick (with no arguments)"
}
}