# Authored By: Tyyphoon95 (https://github.com/Tyyphoon95)
# Date: 09DEC2025
# Version: 1.5.1

Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                       Import Certificates - POWERSHELL SCRIPT         			                                          ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###          This script can take a provided folder containing certificates and automatically import them into the Current User location.   	  ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                        When prompted, provide the FULL path to the folder containing the certificates.                                      ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###               After that, provide the FULL path, including file name, to the text file containing the certificate passwords.                ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###                                                                                                                                             ###`r"
Write-Host -BackgroundColor Black -ForegroundColor Green "###################################################################################################################################################`r"

$check = 0
$check2 = 0
$check3 = 0
$check4 = 0
$counting = 0

function Cert-Find{
	Param([parameter(Position=0)]
		  [string[]]$clean_name,
		  [parameter(Position=1)]
		  [string[]]$line_trim,
		  [parameter(Position=2)]
		  [string[]]$flag
		)
		
	# Function to generate regex query off of Key IDs and ensures 0x is added to the ID value in every fourth column
	# If flag "-s" is set, it will grab the Serial Number of each key and convert to upper case
	
	$cert_id = ($clean_name -replace $line_trim).Trim()
	$cert_split = ("(\s{1,}0x|\s{1,})"+(($cert_id -split '\d{1,2} CA \d{1,2} ') -replace "0x", "")) -replace "\s{1,}", ""
	$cert_split_clean = $cert_split -replace "\s{1,}(0x\s{1,}0x|0x\s{1,})", "(\s{1,}0x|\s{1,})"
	if ($flag -eq "-f"){
		$cert_clean = (($cert_id.Trim() -replace "\s{1,}[a-zA-Z0-9]{3,}", $cert_split_clean) -replace "\s{1,}", "(\s){1,}")
		return $cert_clean
	}
	
	else{
		$serial_upper = ($cert_split_clean.Replace("(\s{1,}0x|\s{1,})", "")).ToUpper()
		return $serial_upper
	}
}

function Display-Error{
	$error_dir = "\ErrorLog\error_"
	$error_file = $error_dir + $date + ".txt"
	$full_error_path = Join-Path -Path $cert_folder -ChildPath $error_file
	$item_check = Get-Item $full_error_path -ErrorAction SilentlyContinue
	if ($item_check -eq $null){
		New-Item -Path $full_error_path -ItemType File -Force | Out-Null
	}
	return $full_error_path
}


do {
	$cert_folder = Read-Host -Prompt "`nPlease enter the path to the folder containing the certificates. `n`tEnsure the last '\' is added to prevent errors from arising"
	$cert_pwds = Read-Host -Prompt "`nPlease enter the path to the text file containing certificate passwords, including the file name"
	$date = Get-Date -Format FileDate

	$cert_name = Get-ChildItem -Path $cert_folder -Name # | Sort-Object
	Write-Host "`nThere are" $cert_name.Count "items within the folder"
	$read_pwds =  ((((Get-Content -Path $cert_pwds) -replace '(SR-[0-9]{1,})', "`t") -replace '(\t{1,}| {2,})', " ")).Trim()

ForEach ($name in $cert_name){

	if ($name -match '.p12' -and $name_clean -ne ""){
		# Locates Certificate files in the location provided, focuses only on those ending in .P12"
		$name_clean = ($name -replace '.p12')  # Name of certificate file without .p12 extension
		$check++
		
		ForEach ($line in $read_pwds) {
			$trim_line = (($line.Trim()) -replace "`t+", " ") -replace " +", " " # Returns Named Section in certificate pwd file

			
			if (($name_clean.Contains($trim_line)) -and ($trim_line -ne "")){ #Finds Named Header in certificate pwd file

				$cert_reg = Cert-Find $name_clean $trim_line "-f"
				$cert_serial = Cert-Find $name_clean $trim_line "-s"

				$search = $read_pwds | Select-String -Pattern $cert_reg
				$check2++

				
				if ($search -ne $null){
					$pwd_reg = "\d{1,2}(\s){1,}CA(\s){1,}\d{1,2}(\s{1,}0x|\s{1,})[a-zA-Z0-9]{3,10}\s{1}"
					$pwds_plain = ($search -replace $pwd_reg,"").Trim()
					$check2++
					$full_path = $cert_folder + $name
					$pwds_secure = ConvertTo-SecureString -String $pwds_plain -AsPlainText -Force
					try {
					Import-PfxCertificate -FilePath $full_path -Password $pwds_secure -CertStoreLocation Cert:\CurrentUser\My | Out-Null
					$counting++
					}
					catch {
						$catch_err = "`n Installation of " + $name_clean + " failed for some reason"
						Write-Host $catch_err
						$err_file_path = Display-Error
						$catch_err >> $err_file_path
					}
					
					$checker = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object SerialNumber -eq $cert_serial

					if ($checker -eq $null){
						$bad_checker = "`n Certificate " + $name_clean + " might not have been successfully added."
						Write-Host $bad_checker
						$checker_error = Display-Error
						$bad_checker >> $checker_error
						$check3++
					}
				}
				
				else {
					$bad_pass = "`nCertificate " + $name_clean + " does not have a matching password in the file you provided`n"
					Write-Host -ForegroundColor Red $bad_pass
					$fe_path = Display-Error
					$bad_pass >> $fe_path
					$check4++
				}
			}
		}
	}
}
Write-Host "`n" $check + $counting + $check3 + $check4
$path = Display-Error
Write-Host "`nAny errors are being recorded to" $path "`n"
Write-Host -ForegroundColor Red "Confirm if the prevailing certs were added successfully, if not add them manually, as the password likely contained characters that couldn't be processed by this tool`r`n"
Write-Host "Approximately" $check "have the file extension of .p12 and" $counting "certs have been loaded successfully"
Clear-Variable -name check
$exit = "C"
$exit = Read-Host -Prompt "`nPlease enter the letter X to exit or C to continue"
}
until ($exit -eq "X"){
	break
}
# $pwds_secure = ConvertTo-SecureString -String {VARIABLE} -AsPlainText -Force