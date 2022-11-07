try {
    
    $homedir = $env:USERPROFILE
    $tfflickpath = $homedir+"\.tfflick"
    $tfversions  = $tfflickpath+"\tfversions"
    
    Start-Transcript -Path $tfflickpath"\tfflick_install_log.txt" -Append
    
    # Find destination directory - typically in the format C:\<home directory>\Documents\WindowsPowerShell\Modules
    $destination = $env:PSModulePath -split ";" | Where-Object {$_ -like $homedir+"*WindowsPowerShell\Modules*"}

    # Copy tfflick module to destination directory
    Copy-Item -Path ".\tfflick" -Destination $destination -Recurse -Force

    # Check if module has been installed correctly
    Write-Host "**********************"
    Write-Host "Checking if tfflick was installed successfully `n"
    
    $checkmodule = Get-Module -ListAvailable | Where-Object {$_.name -like "tfflick"} | Select-Object Name
    if ($checkmodule.Name -eq "tfflick") { 
        Write-Host "tfflick module found in the module library"
        Write-Host $checkmodule
        Write-Host "`n"       
    }  
    
    # Create tfversions directory to hold all downloaded Terraform versions        
    if (-not(Test-Path -Path $tfversions)) {
    Write-Host "**********************"
    Write-Host "Creating $tfversions directory"
    New-Item $tfversions -ItemType Directory
    }
   
    # Create path if it doesn't exist
    $tfflickpathenv = $homedir+"\.tfflick;"
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
        [Environment]::SetEnvironmentVariable("Path", $tfflickpathenv + [Environment]::GetEnvironmentVariable("Path", "User"), "User")

        # Refresh environmental variables
        $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
        $newpath  =  [Environment]::GetEnvironmentVariable("Path","User")

        Write-Host "New User path environment variable:"
        Write-Host $newpath
        Write-Host "`n"
        Write-Host "**********************"
        Write-Host "Test tfflick and set Terraform to latest version"

        $ProgressPreference = 'SilentlyContinue'
        $versionslist = Invoke-WebRequest -URI https://releases.hashicorp.com/terraform/
        $list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
        $latestversion = $list.outerText[0].Substring("terraform_".Length, $list.outerText[0].Length-"terraform_".Length)

        Write-Host "Terraform latest version is " $latestversion

        tfflick $latestversion

        Write-Host "Testing terraform --version command `n"

        $terraformversion = terraform --version
        Write-Host "`n"

        Write-Host $terraformversion
       
        }
}
catch {
    Write-Host "Something went wrong, ensure you have opened Powershell as administrator."
}
finally {
    Stop-Transcript 
}