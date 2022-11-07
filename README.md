# tfflick

## Description

**tfflick** is a Powershell mudule that lets you flick between different versions of Terraform. **tfflick** downloads the specific version you require.
Installation is quick and and you can start using Terraform straight away.

**tfflick** Currently has been tested on Powershell version 5.1 and currently only downloads the Windows AMD64 versions of the Terraform executable

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
* To flick to a specific version number, pass it as the argument. For example `tfflick 1.3.4`

## Release Notes

## 1.0.0

* Initial release of `tfflick` module