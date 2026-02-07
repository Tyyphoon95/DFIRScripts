# Authored By: Tyyphoon95 (https://github.com/Tyyphoon95)
# Date: 06NOV2025
# Version: 1.0.1

Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                       KEYWORD LIST TO DIRECTORY (K2D) - POWERSHELL SCRIPT                                                   ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###          This script can take a provided keyword list and automatically create individual directories as a result of it.                    ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                        When prompted, provide the FULL path to your keyword list including file name.                                       ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###    The output folder path must be the full path, but the final directory does not have to exist as the tool will create it automatically    ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"


do{
$keyword_list = Read-Host -Prompt "`nPlease enter the full path and name of the keyword list used in this case"

if(Test-Path -Path $keyword_list){
    Write-Host "The file was located successfully.......`n"
    $output_path = Read-Host -Prompt "Please enter the location where you would like directories made"
    ForEach ($line in Get-Content $keyword_list) {
        $invalidchars = [IO.path]::GetInvalidFileNameChars() -join ''
        $reg = "[{0}]" -f [RegEx]::Escape($invalidchars)
        $cleaned = ($line -replace $reg)
        New-Item -Path (Join-Path -Path $output_path -ChildPath $cleaned) -ItemType Directory
                }
    }
else{
    Write-Host "This file was not able to be found......."
    }
$exit = "C"
$exit = Read-Host -Prompt "`nPlease enter the letter X to exit or C to continue"
}
until ($exit -eq "X"){
	
}
