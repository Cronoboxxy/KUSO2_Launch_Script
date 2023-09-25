# PSO2 New Genesis Shell Launcher. Made mainly to quickly run PSO2NGSJP after crashing without relogging, Skipping OTP, or just fast login in general.
# Title
$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher"

# File Paths
 # Root path
 Set-Location $PSScriptRoot
 $ksl_path = "$pwd"

# Check if 'ks2-cfg.json' file exists and initialize paths if it doesnt exist
if (-not (Test-Path ".\ks2-cfg.json")) {
  # Check for Tweaker's settings.json file and attempt to get pso2_bin path from it
	$settingsPath = Join-Path $env:APPDATA "PSO2 Tweaker\settings.json"
	Clear-Host
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
						Write-Host "PSO2JP path is not found in settings.json" -ForegroundColor Red
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
					Write-Host "settings.json not found." -ForegroundColor Red
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
    }

    # Convert the configuration data to JSON format
    $configJson = $initConfig | ConvertTo-Json

    # Save the JSON data to 'ks2-cfg.json' in the same directory as the script
    $configJson | Set-Content -Path ".\ks2-cfg.json"
}

	# Read the 'ks2-cfg.json' file from the same directory as the script
	  $configData = Get-Content ".\ks2-cfg.json" | ConvertFrom-Json

	# Path to your 'pso2_bin' folder.
	  $kuso2_bin = $configData.ks2_bin

	# Path to 'kuso2auth' folder.
	  $kuso2_auth = $configData.ks2_auth

	# Valid token age in days.
	  $kuso2_age = $configData.ks2_age

  # Check if 'kuso2_auth' folder exists
  if (-not (Test-Path "$kuso2_auth\KUSO2_Token_Generator.exe")) {
    # If it doesn't exist, attempt to download
    Write-Host ""
	Write-Host "Token generator not found. Downloading it..." -ForegroundColor Yellow
    $url = "https://github.com/Cronoboxxy/KUSO2_Launch_Script/raw/main/ks2_bin/kuso2auth/KUSO2_Token_Generator.exe"
    $downloadPath = Join-Path -Path $kuso2_auth -ChildPath "KUSO2_Token_Generator.exe"
    #Invoke-RestMethod -Uri $url -OutFile (New-Item -Path "$downloadPath" -Force) | Out-Null
    #Invoke-WebRequest -Uri $url -OutFile (New-Item -Path "$downloadPath" -Force) | Out-Null
    Start-BitsTransfer -Source $url -Destination (New-Item -Path "$downloadPath" -Force) | Out-Null
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
    $validResponses = "Q", "q", "R", "r", "S", "s", "C", "c", "E", "e", "T", "t", "V", "v", "X", "x", "Y", "y"
    $reply = $null
    while (!$validResponses.Contains($reply)) {
       # Quick checks
         # Check if pso2.exe exists
         if(-not (Test-Path "$kuso2_bin\pso2.exe")){
            # If it doesn't exist, throw a hissy fit, then exit
                Clear-Host
                Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
                Write-Host ""
                Write-Warning "Could not find 'pso2.exe' in `n`n'$kuso2_bin'"
                Write-Host ""
                Write-Host "Check if above path is the correct path for your 'pso2_bin' folder."
                Write-Host ""
                Write-Host "kuso2launcher will now exit..." -ForegroundColor Red
                Remove-Item ".\ks2-cfg.json" -Force
                Start-Sleep -Seconds 5
                exit
                 }
         # Check if token generator exists
          if(-not (Test-Path "$kuso2_auth\KUSO2_Token_Generator.exe")){
            # If it doesn't exist, throw a hissy fit, then exit
                Clear-Host
                Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
                Write-Host ""
                Write-Warning "Could not find 'KUSO2_Token_Generator.exe' in `n'$kuso2_auth' `n`nMake sure you have the 'kuso2auth' folder that came with this file, `ncontaining the 'KUSO2_Token_Generator.exe' in the same directory!"
                Write-Host ""
                Write-Host "kuso2launcher will now exit..." -ForegroundColor Red
                Start-Sleep -Seconds 5
                exit
		}else {
         # Check if 'auth.tmp' file exists in $kuso2_auth
            if(-not (Test-Path "$kuso2_auth\auth.tmp")){
         # If it doesn't exist, create an empty 'auth.tmp'
              New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
              }
        Clear-Host
        Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
        Write-Host ""
         # Quick check token file age
            $days = $kuso2_age
            $timespan = new-timespan -days $days
              if (((get-date) - (get-item "$kuso2_auth\auth.tmp").LastWriteTime) -gt $timespan) {
         # If older than 1 day (Default), purge existing token
                 Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
                 New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
                 Write-Warning "Token file is older than $days day. For your safety, It has been purged."
                 Write-Host "Please generate a new token If you wish to use it."
                 Write-Host "You can input [T] in the menu to generate a new token without starting the game." -ForegroundColor Green
                 Write-Host ""
                 }
              }
        # Menu
        Write-Host "This will start PSO2NGS. Please check if you have the LATEST login token before starting."
        Write-Host ""
        $reply = Read-Host "1. Press [Enter]: Quickstart with saved token or classic in-game login if no token is stored.`n2. Input [R]: Start with token login and save it for up to $days day(s).`n3. Input [S]: Start with token login but don't save it (per session; no token stored).`n4. Input [X]: Start with token login and save it, with optimization flag disabled.`n5. Input [Y]: Quickstart with saved token, with optimization flag disabled.`n6. Input [C]: Clear any saved token (input [V] to view).`n7. Input [Q]: Exit.`n`nInput preferred option to start"
		
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
        "Q" {
            Write-Host "Exiting..." -ForegroundColor Yellow
            Start-Sleep -Seconds 0.5
            exit
        }
        "R" {
            Clear-Host
            Write-Host "Start PSO2NGS with token login and SAVE login token" -ForegroundColor Yellow
            Write-Host "Generating token. Please log in below."
            # Purging existing token, just to be safe.
            Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
            # Calling the token generator
            Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
            Write-Host ""
            Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
            # Waiting 2 seconds for the token to be written to file, for good measure.
            Start-Sleep -Seconds 1
            # Proceed to launch PSO2NGS
            $auth = Get-Content "$kuso2_auth\auth.tmp"
            Write-Host "Starting NGS... Please Wait." -ForegroundColor Green
            Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
            exit
        }
        "X" {
            Clear-Host
            Write-Host "Start PSO2NGS with token login and SAVE login token" -ForegroundColor Yellow
            Write-Host "Generating token. Please log in below."
            # Purging existing token, just to be safe.
            Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
            # Calling the token generator
            Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
            Write-Host ""
            Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
            # Waiting 2 seconds for the token to be written to file, for good measure.
            Start-Sleep -Seconds 1
            # Proceed to launch PSO2NGS
            $auth = Get-Content "$kuso2_auth\auth.tmp"
            Write-Host "Starting NGS with no optimization... Please Wait." -ForegroundColor Green
            Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth" -WorkingDirectory "$kuso2_bin"
            exit
        }
        "S" {
            Clear-Host
            Write-Host "Start PSO2NGS with token login but NOT SAVE token" -ForegroundColor Yellow
            Write-Host "Generating token. Please log in below."
            # Purging existing token, just to be safe.
            Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
            # Calling the token generator
            Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
            Write-Host ""
            Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
            # Waiting 2 seconds for the token to be written to file, for good measure.
            Start-Sleep -Seconds 1
            # Proceed to launch PSO2NGS
            $auth = Get-Content "$kuso2_auth\auth.tmp"
            Write-Host "Starting NGS... Please Wait." -ForegroundColor Green
            Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
            Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
            exit
        }
        "C" {
            Clear-Host
            Write-Host "Clearing token..." -ForegroundColor Yellow
            Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
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
                 Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -optimize" -WorkingDirectory "$kuso2_bin"
                 } else {
                 Write-Host "Starting NGS... Please Wait." -ForegroundColor Yellow
                 Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize" -WorkingDirectory "$kuso2_bin"
                 }
            # Exit immediately after launch
            exit 0
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
                 } else {
                 Write-Host "Starting NGS with no optimization... Please Wait." -ForegroundColor Yellow
                 Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth" -WorkingDirectory "$kuso2_bin"
                 }
            # Exit immediately after launch
            exit 0
        }
        "T" {
            Clear-Host
            Write-Host "Generate login token but NOT start PSO2NGS" -ForegroundColor Yellow
            Write-Host "Generating token. Please log in below."
            # Purging existing token, just to be safe.
            Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
            # Calling the token generator
            Start-Process -FilePath "$kuso2_auth\KUSO2_Token_Generator.exe" -WorkingDirectory "$kuso2_auth" -Wait -NoNewWindow
            Write-Host ""
            Write-Host "Waiting for the generated token..." -ForegroundColor Yellow
            Write-Host "Done!" -ForegroundColor Green
            Start-Sleep -Seconds 1
            continue
        }
        "V" {
            # Debug/testing option; you can view token through program by inputting [V] in the selection menu.
            Clear-Host
            Write-Host " - - Debug: View saved token - - "
            Write-Warning "This will let you view RAW token string. `nPlease STOP and EXIT if you are doing screen shares and/or in public areas!"
            Write-Host ""
            Write-Host "NEVER share your login token with anyone!" -ForegroundColor Red
            Write-Host ""
            Read-Host "Press any key to view . . ."
            Clear-Host
            Write-Host " - - Debug: View saved token - - "
            Write-Host ""
            Write-Host "Saved token:"
            Write-Host ""
            # Check if the token file is empty or not
              $fileSize = (Get-Item "$kuso2_auth\auth.tmp").length
            # Check token file last generation date
              $fileDate = (Get-Item "$kuso2_auth\auth.tmp").LastWriteTime
            # If empty, say something; else show token info:
              if ($fileSize -le 0) {
                 Write-Host "Token file is empty. `n`nyou can generate a new token without starting the game by pressing [T] `nin the menu screen or launch the game using the classic in-game login." -ForegroundColor Green
                 } else {
                 $auth = Get-Content "$kuso2_auth\auth.tmp"
                 Write-Host "$auth" -ForegroundColor Yellow
                 Write-Host ""
                 Write-Host "Token generated on $fileDate"
                 }
            Write-Host ""
            Read-Host "Press any key to go back to the menu..."
            continue
        }
    }
}
