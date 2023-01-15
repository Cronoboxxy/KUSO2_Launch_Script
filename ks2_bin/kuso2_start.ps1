# PSO2 New Genesis Shell Launcher. Made mainly to quickly run PSO2NGSJP after crashing without relogging, rewritten for fast login in general.
# Place this file along with the 'kuso2auth' folder containing the token generator in your 'pso2_bin' folder, where your pso2.exe is located (You can change and then shortcut of this file anywhere below).

# File Paths (Editable)
  # Path to your 'pso2_bin' folder, where your pso2.exe is located, you can change it here. (By default is the same folder as this script, which is "$PSScriptRoot")
      $kuso2_bin = "$PSScriptRoot" # If you want to store the script somewhere else and not the default, you can point this to your 'pso2_bin' folder; Eg. Editing "$PSScriptRoot" to "C:\PHANTASYSTARONLINE2_JP\pso2_bin"
	
  # Path to 'kuso2auth' folder, where the token generator is located, you can change it here. (Default is kuso2auth folder, which is placed in the same folder of this script, which is "$PSScriptRoot\kuso2auth")
      $kuso2_auth = "$PSScriptRoot\kuso2auth"  # eg. Edit this if you want to store the script/token somewhere else thats safer and not the same folder as the script.

# You MUST to generate a new token after:
# A PC restart, gameserver maintenance, and after logging in the game using the Tweaker, the official launcher, and/or on another PC.
# Using other launchers generate different tokens and you'd want to use the latest generated token in order to avoid being flagged by the game server, Just to be safe.

# Title
$host.UI.RawUI.WindowTitle = "PSO2 New Genesis Shell Launcher"

# Main
while ($true) {
    $validResponses = "Q", "q", "R", "r", "S", "s", "C", "c", "Y", "y", "T", "t", "V", "v"
    $reply = $null
    while (!$validResponses.Contains($reply)) {
       # Menu
         # Check if 'kuso2auth' folder exists
           if( -not (Test-Path "$kuso2_auth\KUSO2_Token_Generator.exe") ){
         # If it doesn't exist, throw a hissy fit, then exit
             Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
             Write-Host ""
             Write-Warning "Could not find 'KUSO2_Token_Generator.exe' in `n'$kuso2_auth' `n`nMake sure you have the 'kuso2auth' folder that came with this file, `ncontaining the 'KUSO2_Token_Generator.exe' in the same directory!"
             Write-Host ""
             Write-Host "The script will now exit..." -ForegroundColor Red
             Start-Sleep -Seconds 10
             exit
              }else {
         # Check if 'auth.tmp' file exists in $kuso2_auth
            if( -not (Test-Path "$kuso2_auth\auth.tmp") ){
         # If it doesn't exist, create an empty 'auth.tmp'
              New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
              }
        Clear-Host
        Write-Host " - - PSO2 New Genesis Shell Launcher - -" -ForegroundColor Yellow
        Write-Host ""
         # Quick check token file age
            $days = 1
            $timespan = new-timespan -days 1
         # If older than 1 day, purge existing token
              if (((get-date) - (get-item "$kuso2_auth\auth.tmp").LastWriteTime) -gt $timespan) {
         # If older than 1 day, purge existing token
                 Remove-Item "$kuso2_auth\auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
                 New-Item "$kuso2_auth\auth.tmp" -ItemType File | Out-Null
                 Write-Warning "Token file is older than 1 day. For your safety, It has been purged."
                 Write-Host "Please generate a new token If you wish to use it."
                 Write-Host "You can input [T] in the menu to generate a new token without starting the game." -ForegroundColor Green
                 Write-Host ""
                 }
              }
        # Hello
        Write-Host "This will start PSO2NGS. Please check if you have the LATEST login token before starting."
        Write-Host ""
        $reply = Read-Host "Press [Enter] to QUICKSTART PSO2NGS with saved token (classic in-game login if no token is stored).`nInput [R] to START PSO2NGS with token login and SAVE login token (persistent token; up to a day).`nInput [S] to START PSO2NGS with token login but NOT SAVE token (per session; no token stored).`nInput [C] to CLEAR any saved token (you can input [V] to VIEW saved token).`nInput [Q] to EXIT.`n`nInput preferred option to start"
		
		# Blank input will always quickstart PSO2NGS.
		if(-not $reply) {
		    $reply = "Y"
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
            Write-Host "Generating token. Please log in with the Token Generator. Do not close this window."
            cd "$kuso2_auth"
            # Purging existing token, just to be safe.
            Remove-Item "auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "auth.tmp" -ItemType File | Out-Null
            # Calling the token generator
            Start-Process -FilePath "KUSO2_Token_Generator.exe" -Wait
            Write-Host ""
            Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
            # Waiting 2 seconds for the token to be written to file, for good measure.
            Start-Sleep -Seconds 2
            # Proceed to launch PSO2NGS
            cd "$PSScriptRoot"
            $auth = Get-Content "$kuso2_auth\auth.tmp"
            cd "$kuso2_bin"
            Write-Host "Starting NGS... Please Wait." -ForegroundColor Green
            Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize"
            exit
        }
        "S" {
            Clear-Host
            Write-Host "Start PSO2NGS with token login but NOT SAVE token" -ForegroundColor Yellow
            Write-Host "Generating token. Please log in with the Token Generator. Do not close this window."
            cd "$kuso2_auth"
            # Purging existing token, just to be safe.
            Remove-Item "auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "auth.tmp" -ItemType File | Out-Null
            # Calling the token generator
            Start-Process -FilePath "KUSO2_Token_Generator.exe" -Wait
            Write-Host ""
            Write-Host "Waiting for the generated token before starting..." -ForegroundColor Yellow
            # Waiting 2 seconds for the token to be written to file, for good measure.
            Start-Sleep -Seconds 2
            # Proceed to launch PSO2NGS
            cd "$PSScriptRoot"
            $auth = Get-Content "$kuso2_auth\auth.tmp"
            cd "$kuso2_bin"
            Write-Host "Starting NGS... Please Wait." -ForegroundColor Green
            Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize"
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
        "Y" {
            Clear-Host
            # Check token size
            $fileSize = (Get-Item "$kuso2_auth\auth.tmp").length
            $auth = Get-Content "$kuso2_auth\auth.tmp"
            # If empty, Launch PSO2NGS without token flag; else Launch PSO2NGS normally:
              if ($fileSize -le 0) {
                 cd "$kuso2_bin"
                 Write-Host "Starting NGS... Please Wait." -ForegroundColor Yellow
                 Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -optimize"
                 } else {
                 cd "$kuso2_bin"
                 Write-Host "Starting NGS... Please Wait." -ForegroundColor Yellow
                 Start-Process -FilePath "pso2.exe" -ArgumentList "-reboot -sgtoken $auth -optimize"
                 }
            # Exit immediately after launch
            exit 0
        }
        "T" {
            Clear-Host
            Write-Host "Generate login token but NOT start PSO2NGS" -ForegroundColor Yellow
            Write-Host "Generating token. Please log in with the Token Generator. Do not close this window."
            cd "$kuso2_auth"
            # Purging existing token, just to be safe.
            Remove-Item "auth.tmp" -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item "auth.tmp" -ItemType File | Out-Null
            # Calling the token generator
            Start-Process -FilePath "KUSO2_Token_Generator.exe" -Wait
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
