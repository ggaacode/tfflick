try {
    
    $homedir = $env:USERPROFILE
    $tfflickpath = $homedir+"\.tfflick"
    $tfversions  = $tfflickpath+"\tfversions"
    
    Start-Transcript -Path $tfflickpath"\tfflick_install_log.txt" -Append
    
    # Find destination directory - typically in the format C:\<home directory>\Documents\WindowsPowerShell\Modules
    $destination = $env:PSModulePath -split ";" | Where-Object {$_ -like $homedir+"*\Documents\WindowsPowerShell*"}

    # Copy tfflick module to destination directory
    Write-Host "**********************"
    Write-Host "Copying module to Powershell Module path - "$destination
    # Copy-Item -Path ".\tfflick" -Destination $destination -Recurse -Force
    
    if ($destination -match '\\WindowsPowerShell\\') {

        if ( $destination -match '\\WindowsPowerShell$'){
            Write-Host "Powershell profile destination found"
        } else {
            $wps = "WindowsPowerShell"        
            $destination = $destination.Substring(0, ($destination.IndexOf($wps)+$wps.Length))
        }

        $MsPSprofileFile = $destination+"\Microsoft.PowerShell_profile.ps1"
        New-Item -path $MsPSprofileFile -ItemType File -Force  
    }

    $tfflick_function_content = Get-Content -Path ".\tfflick\tfflick.psm1"
    Add-Content -Path $MsPSprofileFile -Value $tfflick_function_content

    $aliases = @'
    New-Alias -Name Tf-Flick tfflick
    New-Alias -Name tfswitch tfflick
'@

    Add-Content -Path $MsPSprofileFile -Value $aliases


    # Check tfflick has been copied correctly
    if (Test-Path -Path $destination"\Microsoft.PowerShell_profile.ps1" -PathType Leaf) {
        Write-Host "Module copied successfuly to Powershell Module path"
    }
    else {
        Write-Host "Module was not found at destination check installation log"
        Get-Content ".\generateErrorPath" -ErrorAction STOP
    }

    # Check module has been installed correctly
    Write-Host "**********************"
    Write-Host "Checking if tfflick was installed successfully `n"
    
    # $checkmodule = Get-Module -ListAvailable | Where-Object {$_.name -like "tfflick"} | Select-Object Name
    # if ($checkmodule.Name -eq "tfflick") { 
    #     Write-Host "tfflick module found in the module library"
    #     Write-Host $checkmodule
    #     Write-Host "`n"       
    # }
    # else {
    #     Write-Host "Module not found in module library, please check installation log"
    #     Get-Content ".\generateErrorPath" -ErrorAction STOP
    # }  
    
    # Create tfflick and tfversions working directories to hold all downloaded Terraform versions        
    if (-not(Test-Path -Path $tfversions)) {
        Write-Host "**********************"
        Write-Host "Creating $tfversions directory"
        New-Item $tfversions -ItemType Directory
    }
   
    # Create path if it doesn't exist
    $tfflickpathenv = $homedir+"\.tfflick;"
    $tfflickversionspathenv = $homedir+"\.tfflick\tfversions;"
    $path = [Environment]::GetEnvironmentVariable("Path",[EnvironmentVariableTarget]::User) -split ";"
    if (-not($path | Where-Object {$_ -like "*.tfflick"})){

        # Backup current User path
        $pathbackup = [Environment]::GetEnvironmentVariable("Path","User")
        Write-Host "**********************"
        Write-Host "Current User path:"
        Write-Host $pathbackup
        Write-Host "`n"
        Write-Host "`r"

        Write-Host "Adding tfflick to User path environment variable `n"
        # Adding tfflick to User path environment variable 
        [Environment]::SetEnvironmentVariable("Path", $tfflickversionspathenv + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
        [Environment]::SetEnvironmentVariable("Path", $tfflickpathenv + [Environment]::GetEnvironmentVariable("Path", "User"), "User")  

        # Refresh environmental variables
        $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
        $newpath  =  [Environment]::GetEnvironmentVariable("Path","User")

        Write-Host "New User path environment variable:"
        Write-Host $newpath
        Write-Host "`n"
        Write-Host "**********************"
        Write-Host "Test tfflick and set Terraform to latest version"
        Write-Host "`n"
    }

        
    # Test tfflick and set Terraform to latest version if not already set
    Write-Host "Check if terraform.exe is already set `n"
    if (Test-Path -Path $tfflickpath"\terraform.exe" -PathType leaf) {
        Write-Host "terraform.exe has been previously set to:" 
        $terraformversion = terraform --version
        $terraformversion  
    }
    else {    
        $versionslist = Invoke-WebRequest -URI https://releases.hashicorp.com/terraform/
        $list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
        $latestversion = $list.outerText[0].Substring("terraform_".Length, $list.outerText[0].Length-"terraform_".Length)
    
        Write-Host "Terraform latest version is " $latestversion
        Write-Host "Setting Terraform to version " $latestversion
    
        tfflick $latestversion
        $terraformversion = terraform --version
        Write-Host "Testing terraform --version command" 
        $terraformversion
    }   
}
catch {
    Write-Host "Something went wrong, please review the installation log at "$homedir"\.tfflick\tfflick_install_log.txt"
}
finally {    
    Stop-Transcript 
}