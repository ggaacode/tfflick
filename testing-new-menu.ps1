$baseurl = "https://releases.hashicorp.com/terraform/"

$ProgressPreference = 'SilentlyContinue'
        $versionslist = Invoke-WebRequest -URI $baseurl
        $list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
        # Create list of options to be presented to user. Format: 1.3.4 - terraform_1.3.4
        $shortversionslist =  $list.outerText | ForEach-Object -Process {$_.Substring("terraform_".Length, $_.Length-"terraform_".Length)}

        
        $Options = $shortversionslist
        #$Options[0..4]

        #$Options[0..4] | ForEach-Object -Process {Write-Host $_}

        $RowsIndex = 5
        $Start = 0
        $End = $RowsIndex-1
        $Rows = $Options.count
        $IndexGuide = 2
        $IndexTail = $RowsIndex-$IndexGuide
       # $Options[186]

        $Selection = 0

        

        #$Options[0..4]
    $EnterPressed = $False
        Clear-Host
    
    While($EnterPressed -eq $False){         

        Write-Host -ForegroundColor Red "$Selection"
        Write-Host -ForegroundColor Red "This is Start $Start"
        Write-Host -ForegroundColor Red "This is End $End"
        Write-Host -ForegroundColor Red "This is Rows $Rows"

        for ($i=$Start; $i -le $End; $i++) {
            if ($i -eq $Selection) {
                Write-Host -BackgroundColor White -ForegroundColor Black $Options[$i]
            }
            else
            {
                Write-Host $Options[$i]
            }
        }
        Write-Host -ForegroundColor Green "$Selection"
        Write-Host -ForegroundColor Green "This is Start $Start"
        Write-Host -ForegroundColor Green "This is End $End"
        Write-Host -ForegroundColor Red "This is Rows $Rows"
        
         $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch($KeyInput){
            13{
                $EnterPressed = $True
                Return $Selection          
                Clear-Host
                break
            }           

            38{ #Up
                if ($Selection -ge $RowsIndex-1 -and $Selection -lt ($Rows-1)) {
                    $Selection -= 1
                    $Start -= 1
                    $End -= 1
                }           
                elseif ($Selection -gt 0 -and $Selection -lt $RowsIndex-1) {
                    $Selection -= 1
                    $Start -= 1
                    $End -= 1
                }           
                Clear-Host
                break
            }

            40{ #Down
                if ($Selection -ge 0 -and $Selection -lt $RowsIndex-1) {
                    $Selection += 1
                    $Start = 0
                    $End = $RowsIndex-1
                }
                elseif ($Selection -ge $RowsIndex-1 -and $Selection -lt ($Rows-1)) {
                    $Selection += 1
                    $Start += 1
                    $End += 1
                }               
                Clear-Host
                break
            }            
        
            Default{
                Clear-Host
            }
    }
}    