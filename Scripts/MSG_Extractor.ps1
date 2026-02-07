# Authored By: Tyyphoon95 (https://github.com/Tyyphoon95)
# Date: 28JAN2026
# Version: 1.1.2

Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                      		 MSG Extractor - POWERSHELL SCRIPT         						###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###      	This script can take a provided folder containing multiple email files and save any identified MSG file attachments.   	  	###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                        When prompted, provide the FULL path to the folder containing the MSG files.   	                                ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###             After that, provide the FULL path to the folder where you would like the extracted MSG file attachments to be saved.            ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"

do{
$msg_folder = Read-Host -Prompt "`nPlease enter the path to the folder containing the MSG Files"
$date = Get-Date -Format FileDate
$counter = 0

if(Test-Path -Path $msg_folder){
	$output_path = Join-Path -Path $msg_folder -ChildPath "temp_msgs"
	$tp = Test-Path -Path $output_path
	
	if($tp -ne 'True'){
		New-Item -Path $msg_folder -Name "temp_msgs" -ItemType Directory | Out-Null
	}
	$msg_name = Get-ChildItem -Path $msg_folder -Name -File
	$msg_copy_path = Read-Host -Prompt "Please enter the location where you would like any emails containing embedded MSG files to be saved to"
	$record_file = $msg_copy_path + "\record_" + $date + ".txt"
	ForEach ($name in $msg_name){
		$msg_folder_name = $name.Replace(".MSG","")
		$full_msg_folder = Join-Path -Path $output_path -ChildPath $msg_folder_name
		$file_path = Join-Path -Path $msg_folder -ChildPath $name
		
		if ($name -like "*msg"){
			# $add_name = '.\' + $name
			$name_clean = ($name.Replace('$','`$'))
			$py_var = "/c cd /d $msg_folder && python -m extract_msg $name --extract-embedded --use-filename --out $output_path"
			Start-Process cmd -ArgumentList $py_var -WindowStyle Hidden
			Start-Sleep -Seconds 2
			

			$full_check = Get-ChildItem -Path $full_msg_folder -ErrorAction SilentlyContinue
			
			if (-not $?){
				Write-Host -ForegroundColor Yellow "The file $name was unable to be processed. Please manually review the file and take further action"
			}
			
			if ($full_check -like "*.msg"){
				Remove-Item -Path $full_msg_folder"\message.txt"
				# $move_message = "`n" + $msg_folder_name + " has an embedded MSG file and was moved to " + $msg_copy_path
				# Write-Host $move_message
				# $move_message >> $record_file
				Move-Item -Path $full_msg_folder -Destination $msg_copy_path
				$counter++
			}
			else {
				$no_msg = Join-Path -Path $msg_copy_path -ChildPath "no_embedded_msgs"
				New-Item -Path $no_msg -Name $msg_folder_name -ItemType Directory | Out-Null
				$out_msg = Join-Path -Path $no_msg -ChildPath $msg_folder_name
				Copy-Item -Path $file_path -Destination $out_msg
				
				$bad_checker = "`nEmail file $name did not contain any embedded MSG files. The source file was moved to $out_msg"
				Write-Host -ForegroundColor Red $bad_checker
				$bad_checker >> $record_file
			}
		}
	}
	Write-Host "`nApproximately $counter emails contained an embedded MSG file and need secondary review"
	Write-Host "See $record_file for the entire list of files identified"
}
$exit = "C"
$exit = Read-Host -Prompt "`nPlease enter the letter X to exit or C to continue"
}
until ($exit -eq "X"){
	
}