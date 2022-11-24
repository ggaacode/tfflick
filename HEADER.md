# tfflick

## Description

**tfflick** is a Powershell module that lets you flick between different versions of Terraform. **tfflick** downloads the specific version you require.
Installation is quick and and you can start using Terraform straight away.

Terraform executables are downloaded from https://releases.hashicorp.com/terraform/ 

**tfflick** Currently has been tested on Powershell version 5.1 and currently only downloads the Windows AMD64 versions of the Terraform executable

## Download

* Powershell `Invoke-WebRequest "https://github.com/ggaacode/tfflick/blob/main/tfflick_v1.0.0.Zip?raw=true" -OutFile tfflick_v1.0.0.zip`

## Installation

### Using the installer

Note, you'll need to check your Powershell execution policy before you can run the installer **install_tfflick.ps1** and use **tfflick** in general.

* As Administrator, run `Get-ExecutionPolicy -List` to get your current execution policy.
  
  You should see something like this:
```  
        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser       Undefined
 LocalMachine    RemoteSigned
```

* Ideally LocalMachine should be set to at least **RemoteSigned** and the **tfflick.psm1** module file is unblocked by running the `Unblock-File` command.   

  **Unrestricted** or **Bypass** would not require the file to be unblocked.

* Changing the execution policy. As Administrator, run `Set-ExecutionPolicy RemoteSigned -Scope LocalMachine` 

* Unblocking **tfflick** 

  The installation script can unblock the **tfflick.psm1** module script by running passing the `unblock-tfflick` argument as administrator. See below for details.
 
  If you don't unblock the module, Powershell will prompt you and ask if you wan the file to be unblocked and give you the exact command to run the first time you run **tfflick**. 
 
  For example `Unblock-File -Path 'C:\**home directory**\Documents\WindowsPowerShell\Modules\tfflick\tfflick.psm1'` to run as Administrator.

* For more information about Powershell execution policies, see https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1 

## Run the Installer

Open Poweshell as Administrator and navigate to this folder's location.

Run `.\install_tfflick.ps1` if you don't want the module to be unblocked by the installer 

Or `.\install_tfflick.ps1 unblock-tfflick` to unblock the module during installation

* The installer will copy the module to the C:\\**home directory**\Documents\WindowsPowerShell\Modules directory

* Create an entry in the User `PATH` for the **tfflick** working directory.

* Create the **tfflick** working directory in C:\\**home directory**\ called `.tfflick`.
  This directory contains the Terraform executable and downloaded version.

* Optionally unblock the **tfflick** module



### Manual installation

* Copy the module to the C:\\**home directory**\Documents\WindowsPowerShell\Modules directory

* Create an entry in the User `PATH`

* Create the **tfflick** working directory in C:\\**home directory**\ called `.tfflick`

### Removal

* Currently only manual removal is possible. Undo all steps in Manual installation. 
