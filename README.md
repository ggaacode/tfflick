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

## Usage

### `tfflick`
* Returns a list of available Terraform versions
* Enter the required version at the prompt

### `tfflick {version number}`
* To flick to a specific version number, pass desired version as the argument. For example `tfflick 1.3.4`

## Release Notes

## 1.0.0

* Initial release of `tfflick` module

## Credits
 
 * Create-Menu function developed by JDDellGuy at https://community.spiceworks.com/people/josiahdeal3479
   https://community.spiceworks.com/scripts/show/4785-create-menu-2-0-arrow-key-driven-powershell-menu-for-scripts
   Renamed the function to __tfflick_menu to minimise chances of accidentally callig the function via the tfflick module
   Un-initialised variable $Columns and set the value in the main function body - $Columns = "Auto"