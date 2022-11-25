## Known Issues

* The **Terraform** executable path can clash with pre-existing paths. 
  For example, if **Chocolatey** has previously used to install **Terraform** you might only see this version when running the **Terraform** executable.

  A workaround is to go to **Chocolatey's** bin directory and delete the **terraform** executable. Typically located at `C:\ProgramData\chocolatey\bin`