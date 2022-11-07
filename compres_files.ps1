terraform-docs.exe .

$compress = @{
    Path = ".\tfflick", ".\install_tfflick.ps1", ".\README.md"
    CompressionLevel = "Fastest"
    DestinationPath = ".\tfflick_v1.0.0.Zip"
  }
  Compress-Archive @compress -Force