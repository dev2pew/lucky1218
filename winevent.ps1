Get-ChildItem -Path $PSScriptRoot -Filter "win_event*.txt" -File |
    Remove-Item -Force
