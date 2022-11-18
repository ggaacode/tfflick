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
        $End = $RowsIndex
        $Rows = $Options.count

        $Selection = 0

        

        #$Options[0..4]
    $EnterPressed = $False
        Clear-Host
    
    While($EnterPressed -eq $False){         

        Write-Host -ForegroundColor Red "$Selection"
        Write-Host -ForegroundColor Red "This is Start $Start"
        Write-Host -ForegroundColor Red "This is End $End"

        for ($i=$Start; $i -lt $End; $i++) {
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
        
         $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch($KeyInput){
            13{
                $EnterPressed = $True
                Return $Selection          
                Clear-Host
                break
            }           

            38{ #Up
                if ($Selection -gt 0){                   
                    $Selection -= 1
                }

                if ($Selection -lt $End-1 -and $End -le $RowsIndex) {
                    $Start = 0         
                }
                ilseIf ($Selection -ge $End-1 -and $End -gt $RowsIndex) {
                     $Start += 1
                     $End += 1
                }              

                Clear-Host
                break
            }

            40{ #Down
                if ($Selection -lt $Rows){                    
                    $Selection += 1
                }

                if ($Selection -lt $End-1 -and $End-1 -eq $RowsIndex-1) {
                    $Start = 0 
                    $End = $RowsIndex        
                }
                elseIf ($Selection -ge $End-1 -and $End-1 -ge $RowsIndex-1 -and $End -le ($Rows-1)-($RowsIndex-1)) {
                     $Start += 1
                     $End = $Start+$RowsIndex
                }
                elseif ($Selection -ge ($Rows-1)-($RowsIndex-1) -and $Start -eq ($Rows-1)-($RowsIndex-1)) {
                    $Start = ($Rows-1)-($RowsIndex-1)
                    $End = $Rows-1
                }              

                Clear-Host
                break
            }
            Default{
                Clear-Host
            }
        }
    }