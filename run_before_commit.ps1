terraform-docs.exe .

$compress = @{
    Path = ".\tfflick", ".\install_tfflick.ps1", ".\README.md" #, ".\install_tfflick_method2.ps1"
    CompressionLevel = "Fastest"
    DestinationPath = ".\tfflick_v1.0.0.zip"
  }
  Compress-Archive @compress -Force