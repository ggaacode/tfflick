$baseurl = "https://releases.hashicorp.com/terraform/"

$ProgressPreference = 'SilentlyContinue'
        $versionslist = Invoke-WebRequest -URI $baseurl
        $list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
        # Create list of options to be presented to user. Format: 1.3.4 - terraform_1.3.4
        $shortversionslist =  $list.outerText | ForEach-Object -Process {$_.Substring("terraform_".Length, $_.Length-"terraform_".Length)}

        
        $Options = $shortversionslist

        $Options | ForEach-Object -Process {Write-Host $_}

        While($EnterPressed -eq $False){
        
            Write-Host "$MenuTitle"
            
            If ($ShowCurrentSelection -eq $True){
               $Host.UI.RawUI.WindowTitle = "CURRENT SELECTION: $($MenuOptions[$Selection])"
            }
            
            Write-Host -ForegroundColor Red "$Selection"
            Write-Host "This is RowQty $RowQty"
            Write-Host "This is Columns $Columns"
    
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
            Write-Host -ForegroundColor Green "$Selection"
    
            # Write-Host -ForegroundColor Red "$Selection"
    
            # For ($i=0; $i -lt $RowQty; $i++){
    
            #     For($j=0; $j -le (($Columns-1)*$RowQty);$j+=$RowQty){
    
            #         If($j -eq (($Columns-1)*$RowQty)){
            #             If(($i+$j) -eq $Selection){
            #                 Write-Host -BackgroundColor cyan -ForegroundColor Black "$($MenuListing[$i+$j])"
            #             } Else {
            #                 Write-Host "$($MenuListing[$i+$j])"
            #             }
            #         } Else {
    
            #             If(($i+$j) -eq $Selection){
            #                 Write-Host -BackgroundColor Cyan -ForegroundColor Black "$($MenuListing[$i+$j])" -NoNewline
            #             } Else {
            #                 Write-Host "$($MenuListing[$i+$j])" -NoNewline
            #             }
            #         }
                    
            #     }
    
            # }
    
            #Uncomment the below line if you need to do live debugging of the current index selection. It will put it in green below the selection listing.
            # Write-Host -ForegroundColor Green "$Selection"
    
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