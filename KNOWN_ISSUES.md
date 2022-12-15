## Known Issues

* The **Terraform** executable path can clash with pre-existing paths. 
  For example, if **Chocolatey** has previously used to install **Terraform** you might only see this version when running the **Terraform** executable.

  A workaround is to go to **Chocolatey's** bin directory and delete the **terraform** executable. Typically located at `C:\ProgramData\chocolatey\bin`

* You might see this error in the installation log if you've never used Internet Explorer. Most likely Internet Explorer will bring a pop up window asking to complete the set up. The work around is to follo the instructions in the pop up window and retry the installation.

Error:
```
TerminatingError(Invoke-WebRequest): "The response content cannot be parsed because the Internet Explorer engine is not available, or Internet Explorer's first-launch configuration is not complete. Specify the UseBasicParsing parameter and try again. "
```