## Usage

 `tfflick`
* Returns a menu list of available Terraform versions
* Use your arrow keys to select the desired version and press enter

![alt text](tfflick_no_args.jpg)

 `tfflick {version number}`
* Pass desired version as the argument. For example `tfflick 1.3.4`

![alt text](tfflick_pass_version.jpg)

 `tfflick -h` or `tfflick help`
* Displays `tfflick` usage options

![alt text](tfflick_help_menu.jpg)

## Git Bash

You can use a limited version of `tfflick` in **Git Bash**. It allows to download and change **Terraform** versions by calling `tfflick {version number}` or `tfflick -h` or `tfflick help`. 
The scrolling menu is not available in **Git Bash**

**Procedure**

In **Git Bash**, append this code to your `~/.bash_profile` file. If the file doesn't exist, you can create it.

`vim ~/.bash_profile`

Paste/append this code in .bashrc

```
function tfflick(){
        if [ -z "$1" ]
        then
                echo "Please pass the desired Terraform version number as an argument"
                echo "Example: tfflick 1.3.5"
				echo "Alternatively use tfflick in a Powershell window"
        else
                powershell -command tfflick "$1"
				echo "tfflick has limited functionality in Git Bash."
				echo "To use the full version of tfflick try it in a Powershell window"
        fi
}
```

Then run: 

`source .bash_profile`
