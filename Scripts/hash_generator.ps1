# Authored By: Tyyphoon95 (https://github.com/Tyyphoon95)
# Date: 16DEC2025
# Version: 1.0.1

Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                               Hash Generator - POWERSHELL SCRIPT                                                            ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###          This script can take a provided folder containing files, automatically hash them and save the values to a provided file.           ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                  When prompted, provide the FULL path to the folder containing the files you would like hashed.                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###          Then, provide the hashing algorithm you would like to use (Note: Only SHA1, SHA256, SHA384. SHA512, and MD5 are supported)         ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###            After that, provide the FULL path, including file name, to the text file where you would like the results be saved to.           ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"

do {
$input_folder = Read-Host -Prompt "`nPlease enter the path to the folder containing the files you would like hashed"
$algo = Read-Host -Prompt "`nPlease enter the hashing algorithm you would like to use on these files. (Ex. SHA256 or MD5)"

$output_file = Read-Host -Prompt "`nPlease enter the path to the text file where you would like the hashes saved to, including the file name"

$folder_child = Get-ChildItem -Path $input_folder -Recurse -Name

ForEach ($name in $folder_child){
	if ($name -match "\.[a-zA-Z0-9]{2,}$" -and $name -notmatch "\.E\d{2}$"){
		$full_path = Join-Path -Path $input_folder -ChildPath $name
		$file_info = Get-Item -Path $full_path
		$file_hash = Get-FileHash -Algorithm $algo -Path $full_path 
	
		$name_out = "File Name: " + $name 
		$length_out = "`t`tFile Size: " + ($file_info).Length + " bytes" 
		$algo_out = "`t`t" + $algo + "Hash: " + ($file_hash).Hash + "`r`n"
	
		$name_out | Out-File -FilePath $output_file -Append
		$length_out | Out-File -FilePath $output_file -Append
		$algo_out | Out-File -FilePath $output_file -Append
	}
	elseif ($name -match "\.E\d{2}$") {
		$e01_clean_out = ("Skipping file " + "'" + $name + "'" + " as it is an Image File").Trim()
		Write-Host $e01_clean_out
	}
	else {
		$clean_out = ("Skipping file " + "'" + $name + "'" + " as it is a Folder").Trim()
		Write-Host $clean_out
	}
}
(Get-Content -Path $output_file) -replace "\x00", ""
$exit = "C"
$exit = Read-Host -Prompt "`nPlease enter the letter X to exit or C to continue"
}
until ($exit -eq "X"){
	
}
