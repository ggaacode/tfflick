﻿# Credits
# Create-Menu function developed by JDDellGuy at https://community.spiceworks.com/people/josiahdeal3479
# https://community.spiceworks.com/scripts/show/4785-create-menu-2-0-arrow-key-driven-powershell-menu-for-scripts
# Renamed the function to __tfflick_menu to minimise chances of accidentally callig the function via the tfflick module
# Un-initialised variable $Columns and set the value in the main function body - $Columns = "Auto"
Function __tfflick_menu (){
    #Start-Transcript "C:\_RRC\MenuLog.txt"
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions,
        [Parameter(Mandatory=$True)][String]$Columns,
        [Parameter(Mandatory=$False)][int]$MaximumColumnWidth=20,
        [Parameter(Mandatory=$False)][bool]$ShowCurrentSelection=$False
    )

    $Columns = "Auto"
    $MaxValue = $MenuOptions.count-1
    $Selection = 0
    $EnterPressed = $False

    If ($Columns -eq "Auto"){
        $WindowWidth = (Get-Host).UI.RawUI.MaxWindowSize.Width
        $Columns = [Math]::Floor($WindowWidth/($MaximumColumnWidth+2))
    }

    If ([int]$Columns -gt $MenuOptions.count){
        $Columns = $MenuOptions.count
    }

    $RowQty = ([Math]::Ceiling(($MaxValue+1)/$Columns))
        
    $MenuListing = @()

    For($i=0; $i -lt $Columns; $i++){
            
        $ScratchArray = @()

        For($j=($RowQty*$i); $j -lt ($RowQty*($i+1)); $j++){

            $ScratchArray += $MenuOptions[$j]
        }

        $ColWidth = ($ScratchArray |Measure-Object -Maximum -Property length).Maximum

        If ($ColWidth -gt $MaximumColumnWidth){
            $ColWidth = $MaximumColumnWidth-1
        }

        For($j=0; $j -lt $ScratchArray.count; $j++){
            
            If(($ScratchArray[$j]).length -gt $($MaximumColumnWidth -2)){
                $ScratchArray[$j] = $($ScratchArray[$j]).Substring(0,$($MaximumColumnWidth-4))
                $ScratchArray[$j] = "$($ScratchArray[$j])..."
            } Else {
            
                For ($k=$ScratchArray[$j].length; $k -lt $ColWidth; $k++){
                    $ScratchArray[$j] = "$($ScratchArray[$j]) "
                }

            }
            
            $ScratchArray[$j] = " $($ScratchArray[$j]) "
        }
        $MenuListing += $ScratchArray
    }
    
    Clear-Host

    While($EnterPressed -eq $False){
        
        Write-Host "$MenuTitle"
        
        If ($ShowCurrentSelection -eq $True){
            $Host.UI.RawUI.WindowTitle = "CURRENT SELECTION: $($MenuOptions[$Selection])"
        }

        For ($i=0; $i -lt $RowQty; $i++){

            For($j=0; $j -le (($Columns-1)*$RowQty);$j+=$RowQty){

                If($j -eq (($Columns-1)*$RowQty)){
                    If(($i+$j) -eq $Selection){
                        Write-Host -BackgroundColor cyan -ForegroundColor Black "$($MenuListing[$i+$j])"
                    } Else {
                        Write-Host "$($MenuListing[$i+$j])"
                    }
                } Else {

                    If(($i+$j) -eq $Selection){
                        Write-Host -BackgroundColor Cyan -ForegroundColor Black "$($MenuListing[$i+$j])" -NoNewline
                    } Else {
                        Write-Host "$($MenuListing[$i+$j])" -NoNewline
                    }
                }
                
            }

        }

        #Uncomment the below line if you need to do live debugging of the current index selection. It will put it in green below the selection listing.
        #Write-Host -ForegroundColor Green "$Selection"

        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch($KeyInput){
            13{
                $EnterPressed = $True
                Return $Selection
                Clear-Host
                break
            }

            37{ #Left
                If ($Selection -ge $RowQty){
                    $Selection -= $RowQty
                } Else {
                    $Selection += ($Columns-1)*$RowQty
                }
                Clear-Host
                break
            }

            38{ #Up
                If ((($Selection+$RowQty)%$RowQty) -eq 0){
                    $Selection += $RowQty - 1
                } Else {
                    $Selection -= 1
                }
                Clear-Host
                break
            }

            39{ #Right
                If ([Math]::Ceiling($Selection/$RowQty) -eq $Columns -or ($Selection/$RowQty)+1 -eq $Columns){
                    $Selection -= ($Columns-1)*$RowQty
                } Else {
                    $Selection += $RowQty
                }
                Clear-Host
                break
            }

            40{ #Down
                If ((($Selection+1)%$RowQty) -eq 0 -or $Selection -eq $MaxValue){
                    $Selection = ([Math]::Floor(($Selection)/$RowQty))*$RowQty
                    
                } Else {
                    $Selection += 1
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

Function tfflick {

try {    
    # Accept version number as input parameter
    $argument = $args[0]  

    #Variables
    $homedir     = $env:USERPROFILE
    $tfflickpath = $homedir+"\.tfflick"
    $tfversions  = $tfflickpath+"\tfversions"    
    $versionfile = "terraform_"+$argument+".exe" # Set version format as the file downloads as terraform.exe
    
    # Create tfflick and tfversions working directories to hold all downloaded Terraform versions if it doesn't exist    
    if (-not(Test-Path -Path $tfflickpath)) {
       Write-Host "Creating $tfflickpath\$tfversions directory"
       New-Item $tfflickpath\$tfversions -ItemType Directory
    }
    Function __tfflick_worker {

        Param(
            $argument,
            $tfversions,
            $versionfile,
            $tfflickpath
        )

        $homedir     = $env:USERPROFILE
        $tfflickpath = $homedir+"\.tfflick"
        $tfversions  = $tfflickpath+"\tfversions"    
        $versionfile = "terraform_"+$argument+".exe" # Set version format as the file downloads as terraform.exe

        # Set url and zip file format
        $url = "https://releases.hashicorp.com/terraform/"+$argument+"/terraform_"+$argument+"_windows_amd64.zip"
        $zipfile = "terraform_"+$argument+"_windows_amd64.zip"
          
        # Check if file files already exists. If it does, don't download.
        if (Test-Path -Path $tfversions"\"$versionfile) {
           Write-Host "Version $argument already downloaded"
        }
        elseif ( -not(Test-Path -Path $tfversions"\"$versionfile))
        {
        # Download file if not already in the system
           $ProgressPreference = 'SilentlyContinue'       
           Invoke-WebRequest $url -OutFile $tfflickpath"\"$zipfile
           Write-Host "Downloading version $argument"
           Expand-Archive $tfflickpath"\"$zipfile -DestinationPath $tfversions -Force
           Rename-Item -Path $tfversions"\terraform.exe" -NewName $versionfile -Force       
           Remove-Item -Path $tfflickpath"\"$zipfile -Force
        }
        # Link terraform.exe to selected version.
        New-Item -ItemType HardLink -Path $tfflickpath -Name terraform.exe -Value $tfversions"\"$versionfile -Force
    }

    if  (  -not($argument)) { # Present full list of versions if no argument is provided
        
        # Retrieve list of available Terraform versions
        $ProgressPreference = 'SilentlyContinue'
        $versionslist = Invoke-WebRequest -URI https://releases.hashicorp.com/terraform/
        $list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
        # Create list of options to be presented to user. Format: 1.3.4 - terraform_1.3.4
        $shortversionslist = foreach ($i in $list.outerText) {    
            $i.Substring("terraform_".Length, $i.Length-"terraform_".Length)
        }

        # Display menu list of all available Terraform versions
        $Title = " tfflick `n Select the desired Terraform version and press enter. `n"
        $Options = $shortversionslist
        $Selection = __tfflick_menu -MenuTitle $Title -MenuOptions $Options -Columns "auto" -MaximumColumnWidth 20 -ShowCurrentSelection $True
        Write-Host "You selected version " $shortversionslist[$Selection]
        $argument = $shortversionslist[$Selection]

        __tfflick_worker -argument $argument
    }
    elseif ($argument -match "^[0-9]+.[0-9]+.[0-9]+$") {
        __tfflick_worker -argument $argument
    }        
    elseif ($argument -like "-h" -or $argument -like "help") { # Display tfflick usage options
        $tfflickusage = "## Usage

        * tfflick (no arguments)
        - Returns a menu list of available Terraform versions
        - Use your arrow keys to select the desired version and press enter
        
        * tfflick {version number}
        - To flick to a specific version number, pass the desired version as the argument. For example tfflick 1.3.4 

        * tfflick -h or tfflick help
        - Displays tfflick usage options `n"
        
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