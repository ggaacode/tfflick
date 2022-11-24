try {

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $IsAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)   

    $UnblockFile = $args[0]
    
    $homedir         = $env:USERPROFILE
    $tfflickpath     = $homedir+"\.tfflick"
    $tfversions      = $tfflickpath+"\tfversions"
    $installationlog = $tfflickpath+"\tfflick_install_log.txt"
    
    Start-Transcript -Path $tfflickpath"\tfflick_install_log.txt" -Append

    if (-not($IsAdmin)) {
        Write-Host -ForegroundColor Yellow "Make sure you run the installer as Administrator"
        break
    }
    
    # # Find destination directory - typically in the format C:\<home directory>\Documents\WindowsPowerShell\Modules
    $destination = $env:PSModulePath -split ";" | Where-Object {
        $_.Substring(0,$homedir.Length) -eq $homedir -and $_ -like $homedir+"*WindowsPowerShell\Modules*"}
    if ($destination.Count -gt 0) {        
        Write-Host "**********************"
        Write-Host "Copying module to Powershell Module path - "$destination     
        # Copy tfflick module to destination directory
        Copy-Item -Path ".\tfflick" -Destination $destination -Recurse -Force    
    }
    elseif ($destination.Count -eq  0) {
        $newPSModuleDirectory = $homedir+"\Documents\WindowsPowerShell\Modules"
        Write-Host "**********************"
        Write-Host "Creating Powershell Module path - "$newPSModuleDirectory
        New-Item $newPSModuleDirectory -ItemType Directory
        # Copy tfflick module to destination directory after creating WindowsPowerShell\Modules directory
        Copy-Item -Path ".\tfflick" -Destination $newPSModuleDirectory -Recurse -Force 
    }
    else {
        Write-Host "User modules destination not found please check installation log at "$installationlog
        break
    }      

    # Check tfflick has been copied correctly
    if (Test-Path -Path $destination"\tfflick") {
        Write-Host "Module copied successfuly to Powershell Module path"
        
        if ($UnblockFile -eq "unblock-tfflick") {
            Write-Host "Unlocking tfflick.psm1 module script."
            Unblock-File -Path $destination"\tfflick\tfflick.psm1"
        }
    }
    else {
        Write-Host "Module was not found at destination check installation log at "$installationlog
        break
    }

    # Check module has been installed correctly
    Write-Host "**********************"
    Write-Host "Checking if tfflick was installed successfully `n"
    
    $checkmodule = Get-Module -ListAvailable | Where-Object {$_.name -like "tfflick"} | Select-Object Name
    if ($checkmodule.Name -eq "tfflick") { 
        Write-Host "tfflick module found in the module library"
        Write-Host $checkmodule
        Write-Host "`n"       
    }
    else {
        Write-Host "Module not found in module library, please check installation log at "$installationlog
        break        
    }  
   
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
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12   
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
    Write-Host "Something went wrong, please review the installation log at "$installationlog
}
finally {
    Write-Host "Review installation log at "$installationlog
    Write-Host -NoNewLine 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    Stop-Transcript 
}