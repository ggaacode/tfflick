# tfflick

## Description

**tfflick** is a Powershell module that lets you flick between different versions of Terraform. **tfflick** downloads the specific version you require.
Installation is quick and and you can start using Terraform straight away.

**tfflick** Currently has been tested on Powershell version 5.1 and currently only downloads the Windows AMD64 versions of the Terraform executable

## Download

* Powershell `Invoke-WebRequest "https://github.com/ggaacode/tfflick/blob/main/tfflick_v1.0.0.Zip?raw=true" -OutFile tfflick_v1.0.0.zip`

## Installation

### Using the installer

Open Poweshell and navigate to this folder's location.
Run `.\install_tfflick.ps1`

* The installer will copy the module to the C:\\**home directory**\Documents\WindowsPowerShell\Modules directory
* Create an entry in the User `PATH`
* Create the **tfflick** working directory in C:\\**home directory**\ called `.tfflick`


### Manual installation

* Copy the module to the C:\\**home directory**\Documents\WindowsPowerShell\Modules directory
* Create an entry in the User `PATH`
* Create the **tfflick** working directory in C:\\**home directory**\ called `.tfflick`

### Removal

* Currently only manual removal is possible. Undo all steps in Manual installation. 
