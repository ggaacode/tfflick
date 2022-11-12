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

## Usage

### `tfflick`
* Returns a menu list of available Terraform versions
* Use your arrow keys to select the desired version and press enter

### `tfflick {version number}`
* Pass desired version as the argument. For example `tfflick 1.3.4`

### `tfflick -h` or `tfflick help`
* Displays `tfflick` usage options

## Release Notes

## 1.0.0

* Initial release of `tfflick` module

## To-Do

* Currently working on improving the menu option - The no argument option of `tfflick`. It displays ok when the Powershell window is fully expanded. If the window is not in full mode, the top part of the list is not visible, in this case is better to use the option `tfflick {version number}` 
* Make available for Windows 32 bit architecture - availability to download the 32 bit version of the Terraform executable
* Provide Un-installer option
* Improve menu option - The no argument option of `tfflick`
* Tidy up

## Credits
 
 * Create-Menu function developed by JDDellGuy at https://community.spiceworks.com/people/josiahdeal3479
   https://community.spiceworks.com/scripts/show/4785-create-menu-2-0-arrow-key-driven-powershell-menu-for-scripts
   Renamed the function to __tfflick_menu   