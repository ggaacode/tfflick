
Function __tfflick_shortmenu (){
      
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions,
        [Parameter(Mandatory=$True)][String]$RowsToDisplay,
        [Parameter(Mandatory=$False)][bool]$ShowCurrentSelection=$False    )


$RowsToDisplay = 5
$Start = 0
$End = $RowsToDisplay-1
$Rows = $MenuOptions.count
$Selection = 0
$DownArrow = [char]25
$UpArrow = [char]24
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
                Write-Host -BackgroundColor White -ForegroundColor Black "`t"$MenuOptions[$i] $DownArrow
            }
            elseif ($i -eq $Start -and $Start -ne 0) {
                Write-Host -BackgroundColor White -ForegroundColor Black "`t"$MenuOptions[$i] $UpArrow
            }
            else {
                Write-Host -BackgroundColor White -ForegroundColor Black "`t"$MenuOptions[$i]
            }
        }
        else
        {
            if ($i -eq $End -and $End -ne $Rows-1) {
                Write-Host "`t"$MenuOptions[$i] $DownArrow
            }
            elseif ($i -eq $Start -and $Start -ne 0) {
                Write-Host "`t"$MenuOptions[$i] $UpArrow
            }
            else {
                Write-Host "`t"$MenuOptions[$i]
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

$baseurl = "https://releases.hashicorp.com/terraform/"

$ProgressPreference = 'SilentlyContinue'
$versionslist = Invoke-WebRequest -URI $baseurl
$list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
# Create list of options to be presented to user. Format: 1.3.4 - terraform_1.3.4
$shortversionslist =  $list.outerText | ForEach-Object -Process {$_.Substring("terraform_".Length, $_.Length-"terraform_".Length)}
        
$Title = "     ## tfflick ##`nSelect a Terraform version `nand press enter.`n"
$Options = $shortversionslist

$Selection = __tfflick_shortmenu -MenuTitle $Title -MenuOptions $Options -RowsToDisplay 5 -ShowCurrentSelection $True
Clear-Host
Write-Host "You selected version " $shortversionslist[$Selection]
$argument = $shortversionslist[$Selection]

# Call __tfflick_worker function with selected version
#__tfflick_worker -tfw_argument $argument 