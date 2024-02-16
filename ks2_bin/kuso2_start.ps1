# PSO2 New Genesis Shell Launcher. Made mainly to quickly run PSO2NGSJP after crashing without relogging, Skipping OTP, or just fast login in general.
# Title
$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher"
# File Paths
 # Root path
 Set-Location $PSScriptRoot
 $ksl_path = "$pwd"
# Check if 'ks2-cfg.json' file exists and initialize paths if it doesnt exist
if (-not (Test-Path ".\ks2-cfg.json")) {
  # Check for Tweaker's settings file and attempt to get pso2_bin path from it
	$settingsPath = Join-Path $env:APPDATA "PSO2 Tweaker\settings.json"
	Clear-Host
	$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher: Setup"
	Write-Host " - - PSO2 New Genesis Shell Launcher: First Time Setup- -" -ForegroundColor Yellow
	Write-Host ""
  Write-Host "Looking for stored Tweaker settings..." -ForegroundColor Yellow
	if (Test-Path -Path $settingsPath -PathType Leaf) {
		Write-Host "Tweaker settings found at: $settingsPath" -ForegroundColor Cyan
		Write-Host "Attempting to use it..." -ForegroundColor Yellow
		# Read the settings.json file
		$settingsContent = Get-Content $settingsPath -Raw | ConvertFrom-Json
		Write-Host "Reading and parsing Tweaker settings..." -ForegroundColor Yellow
		# Check if "PSO2JPBinFolder" exists in the settings.json file
		if ($settingsContent.PSO2JPBinFolder) {
			$kuso2_path = $settingsContent.PSO2JPBinFolder
			Write-Host "JP pso2_bin folder found at: $kuso2_path" -ForegroundColor Cyan
			Write-Host "Checking if it exists..." -ForegroundColor Yellow
			# Check if the folder specified in "PSO2JPBinFolder" exists
			if (Test-Path -Path $kuso2_path -PathType Container) {
				Write-Host ""
				Write-Host "$kuso2_path exists!" -ForegroundColor Green
				Write-Host ""
				$confirmpath = ''
				while ($confirmpath -notin @('yes', 'y', 'no', 'n')) {
					$confirmpath = Read-Host "Is this the correct path (Y/N)?"
					if ([string]::IsNullOrEmpty($confirmpath)) {
						$confirmpath = 'yes'
					}
				}
				if ($confirmpath -eq 'no' -or $confirmpath -eq 'n') {
						do {
								# Prompt path for input
								Write-Host ""
								Write-Host "Alright." -ForegroundColor Yellow
								Write-Host ""
								$kuso2_path = Read-Host "Please input/paste your 'pso2_bin' path. It should point to the folder where your 'pso2.exe' is located.`n`nExample:`n`nC:\PHANTASYSTARONLINE2_JP\pso2_bin`n`n"
								# Display the user's input and ask for confirmation
								Write-Host ""
								Write-Host "You entered: $kuso2_path"
								Write-Host ""
								$confirmation = Read-Host "Is this the correct path? (Yes/No):"
								# Everything that's not a yes or y is a no
								if ($confirmation -ne "yes" -and $confirmation -ne "y") {
								}
							} while ($confirmation -ne "yes" -and $confirmation -ne "y")
				}
			} else {
					do {
							# Prompt path for input
							Write-Host ""
							Write-Host "Actual path not found on disk." -ForegroundColor Red
							Write-Host ""
							$kuso2_path = Read-Host "Please input/paste your 'pso2_bin' path. It should point to the folder where your 'pso2.exe' is located.`n`nExample:`n`nC:\PHANTASYSTARONLINE2_JP\pso2_bin`n`n"
							# Display the user's input and ask for confirmation
							Write-Host ""
							Write-Host "You entered: $kuso2_path"
							Write-Host ""
							$confirmation = Read-Host "Is this the correct path? (Yes/No):"
							# Everything that's not a yes or y is a no
							if ($confirmation -ne "yes" -and $confirmation -ne "y") {
							}
						} while ($confirmation -ne "yes" -and $confirmation -ne "y")
			}
		} else {
				do {
						# Prompt path for input
						Write-Host ""
						Write-Host "PSO2JP path is not found in Tweaker settings." -ForegroundColor Red
						Write-Host ""
						$kuso2_path = Read-Host "Please input/paste your 'pso2_bin' path. It should point to the folder where your 'pso2.exe' is located.`n`nExample:`n`nC:\PHANTASYSTARONLINE2_JP\pso2_bin`n`n"
						# Display the user's input and ask for confirmation
						Write-Host ""
						Write-Host "You entered: $kuso2_path"
						Write-Host ""
						$confirmation = Read-Host "Is this the correct path? (Yes/No):"
						# Everything that's not a yes or y is a no
						if ($confirmation -ne "yes" -and $confirmation -ne "y") {
						}
					} while ($confirmation -ne "yes" -and $confirmation -ne "y")
		}
	} else {
			do {
					# Prompt path for input
					Write-Host ""
					Write-Host "Tweaker settings not found." -ForegroundColor Red
					Write-Host ""
					$kuso2_path = Read-Host "Please input/paste your 'pso2_bin' path. It should point to the folder where your 'pso2.exe' is located.`n`nExample:`n`nC:\PHANTASYSTARONLINE2_JP\pso2_bin`n`n"
					# Display the user's input and ask for confirmation
					Write-Host ""
					Write-Host "You entered: $kuso2_path"
					Write-Host ""
					$confirmation = Read-Host "Is this the correct path? (Yes/No):"
					# Everything that's not a yes or y is a no
					if ($confirmation -ne "yes" -and $confirmation -ne "y") {
					}
				} while ($confirmation -ne "yes" -and $confirmation -ne "y")
	}
	# Create initial configuration data
	$initConfig = [PSCustomObject]@{
		"ks2_bin" = $kuso2_path
		"ks2_auth" = "$ksl_path\ks2_auth"
		"ks2_age" = "1"
		"ks2_xign" = "0"
	}
	# Convert the configuration data to JSON format
	$configJson = $initConfig | ConvertTo-Json

	# Save the JSON data to 'ks2-cfg.json' in the same directory as the script
	$configJson | Set-Content -Path ".\ks2-cfg.json"
}
	# Load the 'ks2-cfg.json' file from the same directory as the script
	  $configData = Get-Content ".\ks2-cfg.json" | ConvertFrom-Json
	# Xingcode flag; Check if 'ks2_xign' property exists; add it if it doesnt
	if (-not $configData.PSObject.Properties["ks2_xign"]) {
		$configData | Add-Member -MemberType NoteProperty -Name "ks2_xign" -Value "0"
	}
	# Convert the updated configuration data to JSON format
	$configJson = $configData | ConvertTo-Json
	# Save the JSON data back to 'ks2-cfg.json'
	$configJson | Set-Content -Path ".\ks2-cfg.json"
	# Path to your 'pso2_bin' folder.
	  $kuso2_bin = $configData.ks2_bin
	# Path to 'kuso2auth' folder.
	  $kuso2_auth = $configData.ks2_auth
	# Valid token age in days.
	  $kuso2_age = $configData.ks2_age
	# Anticheat selection.
	  $kuso2_xign = $configData.ks2_xign

  # Check if 'kuso2_auth' folder exists
  if (-not (Test-Path "$kuso2_auth\KUSO2_Token_Generator.exe")) {
	# If it doesn't exist, attempt to download
	Write-Host ""
	$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher: Downloading..."
	Write-Host "Token generator not found. Downloading..." -ForegroundColor DarkYellow
	$url = "https://github.com/Cronoboxxy/KUSO2_Launch_Script/raw/main/ks2_bin/kuso2auth/KUSO2_Token_Generator.exe"
	$downPath = Join-Path -Path $kuso2_auth -ChildPath "KUSO2_Token_Generator.exe"
	$downloadPath = (New-Item -Path "$downPath" -Force)
	#Invoke-RestMethod -Uri $url -OutFile $downloadPath | Out-Null
	#Invoke-WebRequest -Uri $url -OutFile $downloadPath | Out-Null
	#Start-BitsTransfer -Source $url -Destination $downloadPath | Out-Null
	(New-Object Net.WebClient).DownloadFile($url, $downloadPath) | Out-Null
	Write-Host ""
	Write-Host "Downloaded 'KUSO2_Token_Generator.exe' and placed it in" -ForegroundColor Cyan
	Write-Host ""
	Write-Host "'$kuso2_auth'" -ForegroundColor Green
	Start-Sleep -Seconds 3
}
# You MUST to generate a new token after:
# A PC restart, gameserver maintenance, and after logging in the game using the Tweaker, the official launcher, and/or on another PC.
# Using other launchers generate different tokens. Only the latest token generated by te server will be accepted and you'd want to use the latest generated token in order to avoid being flagged by the game server.
# Main
while ($true) {
	$validResponses = "A", "a", "Q", "q", "R", "r", "S", "s", "C", "c", "E", "e", "T", "t", "V", "v", "X", "x", "Y", "y", "Z", "z"
	$reply = $null
	while (!$validResponses.Contains($reply)) {
	   # Startup checks
		 # Check if pso2.exe exists
		 if(-not (Test-Path "$kuso2_bin\pso2.exe")){
			# If it doesn't exist, throw a hissy fit, then exit
				Clear-Host
				$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher: Error"
				Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
				Write-Host ""
				Write-Warning "Could not find 'pso2.exe' in `n`n'$kuso2_bin'"
				Write-Host ""
				Write-Host "Check if above path is the correct path for your 'pso2_bin' folder."
				Write-Host ""
				Write-Host "kuso2launcher will now exit..." -ForegroundColor Red
				Remove-Item ".\ks2-cfg.json" -Force
				Start-Sleep -Seconds 3
				exit
				 }
		 # Check if token generator exists
		  if(-not (Test-Path "$kuso2_auth\KUSO2_Token_Generator.exe")){
			# If it doesn't exist, throw a hissy fit, then exit
				Clear-Host
				$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher: Error"
				Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
				Write-Host ""
				Write-Warning "Could not find 'KUSO2_Token_Generator.exe' in `n'$kuso2_auth' `n`nMake sure you have the 'kuso2auth' folder that came with this file, `ncontaining the 'KUSO2_Token_Generator.exe' in the same directory!"
				Write-Host ""
				Write-Host "kuso2launcher will now exit..." -ForegroundColor Red
				Start-Sleep -Seconds 3
				exit
		}else {
		 # Check if 'auth.tmp' file exists in $kuso2_auth
			if(-not (Test-Path "$kuso2_auth\auth.tmp")){
		 # If it doesn't exist, create an empty 'auth.tmp'
			  New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
			  }
		 # Show anticheat selection.
			if ($kuso2_xign -ge 1) {
				$kuso2_ac = "Wellbia XIGNCODE3™"
			} elseif ($kuso2_xign -eq 0) {
				$kuso2_ac = "nProtect GameGuard™"
			}
		Clear-Host
		$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher - Current Anticheat: $kuso2_ac"
		Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
		Write-Host ""
		 # Quick check token file age
			$days = $kuso2_age
			$timespan = new-timespan -days $days
			  if (((get-date) - (get-item "$kuso2_auth\auth.tmp").LastWriteTime) -gt $timespan) {
		 # If older than 1 day (Default), purge existing token
				 Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
				 New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
				 Write-Warning "Token file is older than $days day. For your safety, It has been purged."
				 Write-Host "Please generate a new token If you wish to use it." -ForegroundColor Gray
				 Write-Host "You can input [T] in the menu to generate a new token without starting the game." -ForegroundColor DarkGreen
				 Write-Host ""
				 }
			  }
		# Menu
		Write-Host "This will start PSO2NGS. Please check if you have the LATEST login token before starting." -ForegroundColor Green
		Write-Host "Current Anticheat: $kuso2_ac. Input [A] to switch." -ForegroundColor Blue
		Write-Host ""
		$reply = Read-Host "1. Press [Enter]: Quickstart with saved token OR classic in-game login if no token is stored.`n2. Input [R]: Start with token login and save it for up to $days day(s).`n3. Input [S]: Start with token login but don't save it (per session; no token stored).`n4. Input [X]: Start with token login and save it, with optimization flag disabled.`n5. Input [Y]: Quickstart with saved token, with optimization flag disabled.`n6. Input [C]: Clear any saved token (input [V] to view).`n7. Input [Q]: Exit.`n`nInput preferred option to start"
		
		# Blank input will always quickstart PSO2NGS.
		if(-not $reply) {
			$reply = "E"
		}
		if (!$validResponses.Contains($reply)) {
		   Write-Warning "Invalid input, please enter a valid option."
		   Start-Sleep -Seconds 1
		   continue
				 }
		}
	switch ($reply.ToUpper()) {
		"A" {
			# You can switch the selected anticheat by inputting [A] in the menu.
			Clear-Host
			$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher: Switching Anticheat From $kuso2_ac"
			Write-Host " - - Anticheat Switching - - " -ForegroundColor Yellow
			Write-Host ""
			Write-Host "This will let you change the anticheat program.`nPlease CHECK if you have the correct anticheat that you'd want to use before starting the game!" -ForegroundColor DarkYellow
			Write-Host ""
			Write-Host "Current Anticheat: $kuso2_ac" -ForegroundColor DarkCyan
			Write-Host ""
			Read-Host "Press [Enter] to switch"
			# Toggle anticheat selection
			if ($kuso2_xign -ge 1) {
				$kuso2_xign = "0"
			} else {
				$kuso2_xign = "1"
			}
			# Update configuration data with the new anticheat selection
			$configData.ks2_xign = $kuso2_xign
			# Save the updated configuration data to 'ks2-cfg.json'
			$configData | ConvertTo-Json | Set-Content -Path ".\ks2-cfg.json"
			# Show current anticheat selection.
			$kuso2_xign = $configData.ks2_xign
			if ($kuso2_xign -ge 1) {
				$kuso2_ac = "Wellbia XIGNCODE3"
			} elseif ($kuso2_xign -eq 0) {
				$kuso2_ac = "nProtect GameGuard"
			}
			Clear-Host
			$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher: Anticheat Switched To $kuso2_ac"
			Write-Host " - - Anticheat Switching - - " -ForegroundColor Yellow
			Write-Host ""
			Write-Host "Anticheat changed!" -ForegroundColor Cyan
			Write-Host ""
			Write-Host "Current Anticheat: $kuso2_ac" -ForegroundColor Green
			Write-Host ""
			Read-Host "Press [Enter] to go back to the menu"
			continue
		}
		"C" {
			Clear-Host
			Write-Host "Clearing token..." -ForegroundColor Yellow
			Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
			New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
			Start-Sleep -Seconds 0.5
			Write-Host "Done!" -ForegroundColor Green
			Start-Sleep -Seconds 1
			continue
		}
		"E" {
			Clear-Host
			# Check token size
			$fileSize = (Get-Item "$kuso2_auth\auth.tmp").length
			$auth = Get-Content "$kuso2_auth\auth.tmp"
			# If empty, Launch PSO2NGS without token flag; else Launch PSO2NGS normally:
			  if ($fileSize -le 0) {
				Write-Host "Starting NGS... Please Wait." -ForegroundColor Yellow
				if ($kuso2_xign -ge 1) {
					Start-Process -FilePath ".\sub\ucldr_PSO2_JP_loader_x64.exe" -ArgumentList "$kuso2_bin\sub\pso2.exe -reboot -optimize" -WorkingDirectory "$kuso2_bin"
				} elseif ($kuso2_xign -eq 0) {
					Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -optimize" -WorkingDirectory "$kuso2_bin"
				}
					} else {
				Write-Host "Starting NGS... Please Wait." -ForegroundColor Yellow
				if ($kuso2_xign -ge 1) {
					Start-Process -FilePath ".\sub\ucldr_PSO2_JP_loader_x64.exe" -ArgumentList "$kuso2_bin\sub\pso2.exe -reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
				} elseif ($kuso2_xign -eq 0) {
					Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
				}
			}
			# Exit immediately after launch
			exit 0
		}
		"Q" {
			Write-Host "Exiting..." -ForegroundColor Yellow
			Start-Sleep -Seconds 1
			exit
		}
		"R" {
			Clear-Host
			Write-Host "Start PSO2NGS with token login and SAVE login token" -ForegroundColor Yellow
			Write-Host "Generating token. Please log in below."
			# Purging existing token, just to be safe.
			Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
			New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
			# Calling the token generator
			Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
			Write-Host ""
			Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
			# Waiting 1 second for the token to be written to file, for good measure.
			Start-Sleep -Seconds 1
			# Proceed to launch PSO2NGS
			$auth = Get-Content "$kuso2_auth\auth.tmp"
			Write-Host "Starting NGS... Please Wait." -ForegroundColor Green
			if ($kuso2_xign -ge 1) {
				Start-Process -FilePath ".\sub\ucldr_PSO2_JP_loader_x64.exe" -ArgumentList "$kuso2_bin\sub\pso2.exe -reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
			} elseif ($kuso2_xign -eq 0) {
				Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
			}
			exit
		}
		"S" {
			Clear-Host
			Write-Host "Start PSO2NGS with token login but NOT SAVE token" -ForegroundColor Yellow
			Write-Host "Generating token. Please log in below."
			# Purging existing token, just to be safe.
			Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
			New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
			# Calling the token generator
			Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
			Write-Host ""
			Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
			# Waiting 1 second for the token to be written to file, for good measure.
			Start-Sleep -Seconds 1
			# Proceed to launch PSO2NGS
			$auth = Get-Content "$kuso2_auth\auth.tmp"
			Write-Host "Starting NGS... Please Wait." -ForegroundColor Green
			if ($kuso2_xign -ge 1) {
				Start-Process -FilePath ".\sub\ucldr_PSO2_JP_loader_x64.exe" -ArgumentList "$kuso2_bin\sub\pso2.exe -reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
			} elseif ($kuso2_xign -eq 0) {
				Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
			}
			Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
			New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
			exit
		}
		"T" {
			Clear-Host
			Write-Host "Generate login token but NOT start PSO2NGS" -ForegroundColor Yellow
			Write-Host "Generating token. Please log in below."
			# Purging existing token, just to be safe.
			Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
			New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
			# Calling the token generator
			Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
			Write-Host ""
			Write-Host "Waiting for the generated token..." -ForegroundColor Yellow
			Write-Host "Done!" -ForegroundColor Green
			Start-Sleep -Seconds 1
			continue
		}
		"V" {
			# You can view token through program by inputting [V] in the menu.
			Clear-Host
			Write-Host " - - View saved token - - " -ForegroundColor Yellow
			Write-Host ""
			Write-Host "This will let you view RAW token string. `nPlease STOP and EXIT if you are doing screen shares and/or in public areas!" -ForegroundColor DarkYellow
			Write-Host ""
			Write-Host "NEVER share your login token with anyone!" -ForegroundColor Red
			Write-Host ""
			Read-Host "Press [Enter] to view"
			Clear-Host
			Write-Host " - - View saved token - - " -ForegroundColor Yellow
			Write-Host ""
			# Check if the token file is empty or not
			  $fileSize = (Get-Item "$kuso2_auth\auth.tmp").length
			# Check token file last generation date
			  $fileDate = (Get-Item "$kuso2_auth\auth.tmp").LastWriteTime
			# If empty, say something; else show token info:
			  if ($fileSize -le 0) {
				 Write-Host "Token file is empty. `n`nYou can generate a new token without starting the game by pressing [T] `nin the menu screen or launch the game using the classic in-game login." -ForegroundColor Green
				 } else {
				 $auth = Get-Content "$kuso2_auth\auth.tmp"
				 Write-Host "Saved token:"
				 Write-Host ""
				 Write-Host "$auth" -ForegroundColor Cyan
				 Write-Host "Token generated on $fileDate" -ForegroundColor Cyan
				 }
			Write-Host ""
			Read-Host "Press [Enter] to go back to the menu"
			continue
		}
		"X" {
			Clear-Host
			Write-Host "Start PSO2NGS with token login and SAVE login token" -ForegroundColor Yellow
			Write-Host "Generating token. Please log in below."
			# Purging existing token, just to be safe.
			Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
			New-Item "$kuso2_auth\auth.tmp" -ItemType File -Force | Out-Null
			# Calling the token generator
			Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
			Write-Host ""
			Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
			# Waiting 1 second for the token to be written to file, for good measure.
			Start-Sleep -Seconds 1
			# Proceed to launch PSO2NGS
			$auth = Get-Content "$kuso2_auth\auth.tmp"
			Write-Host "Starting NGS with no optimization... Please Wait." -ForegroundColor Green
			if ($kuso2_xign -ge 1) {
				Start-Process -FilePath ".\sub\ucldr_PSO2_JP_loader_x64.exe" -ArgumentList "$kuso2_bin\sub\pso2.exe -reboot -sgtoken $auth" -WorkingDirectory "$kuso2_bin"
			} elseif ($kuso2_xign -eq 0) {
				Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth" -WorkingDirectory "$kuso2_bin"
			}
			exit
		}
		"Y" {
			Clear-Host
			# Check token size
			$fileSize = (Get-Item "$kuso2_auth\auth.tmp").length
			$auth = Get-Content "$kuso2_auth\auth.tmp"
			# If empty, Launch PSO2NGS without token flag; else Launch PSO2NGS normally:
			  if ($fileSize -le 0) {
				Write-Host "Starting NGS with no optimization... Please Wait." -ForegroundColor Yellow
				Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot" -WorkingDirectory "$kuso2_bin"
				if ($kuso2_xign -ge 1) {
					Start-Process -FilePath ".\sub\ucldr_PSO2_JP_loader_x64.exe" -ArgumentList "$kuso2_bin\sub\pso2.exe -reboot" -WorkingDirectory "$kuso2_bin"
				} elseif ($kuso2_xign -eq 0) {
					Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot" -WorkingDirectory "$kuso2_bin"
				}
					} else {
				Write-Host "Starting NGS with no optimization... Please Wait." -ForegroundColor Yellow
				Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth" -WorkingDirectory "$kuso2_bin"
				if ($kuso2_xign -ge 1) {
					Start-Process -FilePath ".\sub\ucldr_PSO2_JP_loader_x64.exe" -ArgumentList "$kuso2_bin\sub\pso2.exe -reboot -sgtoken $auth" -WorkingDirectory "$kuso2_bin"
				} elseif ($kuso2_xign -eq 0) {
					Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth" -WorkingDirectory "$kuso2_bin"
				}
			}
			# Exit immediately after launch
			exit 0
		}
		"Z" {
			# Debug/testing option; quickly launch PSO2 Tweaker by inputting [Z] in the selection menu.
			Clear-Host
			Write-Host " - - Debug: Run PSO2 Tweaker - - " -ForegroundColor Blue
			Write-Host ""
			Write-Host "This will start PSO2 Tweaker so you can update, etc." -ForegroundColor Cyan
			Write-Host ""
			Read-Host "Press [Enter] to continue"
			Clear-Host
			# Might as well; just in case
			try {
				Write-Host "Starting PSO2 Tweaker..." -ForegroundColor Yellow
				Write-Host ""
				Write-Host "You can close this window or continue here after closing PSO2 Tweaker." -ForegroundColor DarkGreen
				# Make use of this registry entry Tweaker seems to add/update after each run
				$TwRegisPath = "HKLM:\SOFTWARE\Classes\tweaker\shell\open\command"
				$TwregVal = Get-ItemProperty -LiteralPath $TwRegisPath
				# Get the Tweaker path from the registry value
				$TwexePath = $TwregVal.'(default)' -replace '"%1"', '' -replace '"', ''
				# Get directory and cleanup Tweaker executable path
				$TwDir = Split-Path -Parent $TwexePath
				# Start the Tweaker
				Start-Process -FilePath "$TwexePath" -ArgumentList "-tweakjp" -WorkingDirectory "$TwDir" -Wait
				Write-Host ""
				Write-Host "Done!" -ForegroundColor Yellow
				Start-Sleep -Seconds 1
				continue
			}
			catch {
				Write-Host "An error occurred: $_"
				Write-Host ""
				Read-Host "Press [Enter] to go back to the menu"
				continue
			}
		}
	}
}
