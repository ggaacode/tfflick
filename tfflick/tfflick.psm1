function tfflick {

try {

    # Accept version number as input parameter
    $version = $args[0]  

    # Present full list of versions if no argument was provided
    if  (  -not($version)) {
        
        # Retrieve list of available Terraform versions
        $ProgressPreference = 'SilentlyContinue'
        $versionslist = Invoke-WebRequest -URI https://releases.hashicorp.com/terraform/
        $list = $versionslist.Links | Where-Object {
            $_.outerText -match "^terraform_[0-9]+.[0-9]+.[0-9]+$" -and $_.outerText -notlike "*_0.1.*"
        } | Select-Object outerText
        
        # Create list of options to be presented to user. Format: 1.3.4 - terraform_1.3.4
        $shortversionslist = foreach ($i in $list.outerText) {    
                                       $i.Substring("terraform_".Length, $i.Length-"terraform_".Length)+" - "+$i
                                     }
    
        # Reverse the order of the list to present the latest version at the bottom of the list
        [array]::Reverse($shortversionslist)        
        
        # Set the version to the user selection
        Write-Host "Please select a version number and press enter. Example "$list.outerText[0].Substring("terraform_".Length, $list.outerText[0].Length-"terraform_".Length)
        $version = read-Host ($shortversionslist -join "`n ")
    
    }
    
    # Set version format as the file downloads as terraform.exe
    $versionfile = "terraform_"+$version+".exe"
    
    # Create tfflick required file structure
    $homedir = $env:USERPROFILE
    $tfflickpath = $homedir+"\.tfflick"
    $tfversions = $tfflickpath+"\tfversions"
    
    if (-not(Test-Path -Path $tfflickpath)) {
    Write-Host "Creating $tfflickpath\$tfversions directory"
    New-Item $tfflickpath -ItemType Directory
    }
    # if(-not(Test-Path -Path $tfversions)) {
    # Write-Host "Creating $tfversions directory"
    # New-Item $tfversions -ItemType Directory
    # }
    
    # Set url and zip file format
    $url = "https://releases.hashicorp.com/terraform/"+$version+"/terraform_"+$version+"_windows_amd64.zip"
    $zipfile = "terraform_"+$version+"_windows_amd64.zip"
    
    # Change directory to required location
        
    # Check if file files already exists. If it does, don't download.
    if (Test-Path -Path $tfversions"\"$versionfile) {
       Write-Host "Version $version already downloaded"
    }
    elseif ( -not(Test-Path -Path $tfversions"\"$versionfile))
    {
    # Download file if not already in the system
       $ProgressPreference = 'SilentlyContinue'       
       Invoke-WebRequest $url -OutFile $tfflickpath"\"$zipfile
       Write-Host "Downloading version $version"
       Expand-Archive $tfflickpath"\"$zipfile -DestinationPath $tfversions -Force
       Rename-Item -Path $tfversions"\terraform.exe" -NewName $versionfile -Force       
       Remove-Item -Path $tfflickpath"\"$zipfile -Force
    }
    # Link terraform.exe to selected version.
    New-Item -ItemType HardLink -Path $tfflickpath -Name terraform.exe -Value $tfversions"\"$versionfile -Force
}
catch {
    # Display error message if something goes wrong
    Write-Host "Someting went wrong. Please provide a version number as an argument. For example tfflick 1.3.4"
    Write-Host "To view a full list of available versions try tfflick (with no arguments)"
}

}