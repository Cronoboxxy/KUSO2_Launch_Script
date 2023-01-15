# KUSO2 Launch Script
![](https://cdn.discordapp.com/attachments/865992934612664340/1063578429271842826/image.png)

Originally made just to quickly run PSO2NGS after crashing without relogging in again, this method bypasses the need to launch tweaker or the official launcher for PSO2NGSJP to run, and also makes use of the [PSO2JP_Token_Generator](https://github.com/Cronoboxxy/PSO2JP_Token_Generator) as part of a batch script when run:
 - Starts the game quickly. With or without token login.
 - Loads the token generator and launch the game quickly.
 - Reuse the token and starts the game quickly when needed.
 - Option to clear your token when needed.
 - Clears your token after a set time (Default is 1 day).

This is just a simple launch script to run the game that assumes that you have an up to date version of the game installed and does not do anything beyond the ones listed above. *This script is also only intended to work for the JP ver of the game.*

**You will still need the Tweaker or the official launcher to update the game.**

You can grab and use a working copy of the script by going to [Release](https://github.com/Cronoboxxy/KUSO2_Launch_Script/releases),
and extracting all the contents to your 'pso2_bin' folder, where your pso2.exe is located, and then starting 'kuso2_start.bat'. *You can then place a shortcut of this script anywhere and/or edit it however you want.*

You can also grab the script directly in [this repo](https://github.com/Cronoboxxy/KUSO2_Launch_Script/tree/main/ks2_bin) and edit to your liking and build the token generator from [source](https://github.com/Cronoboxxy/PSO2JP_Token_Generator).

# Account Safety Warning
For your account safety, you **MUST** generate a new token after:
 - Gameserver maintenance
 - Logging in the game using another launcher, and/or logging in on another PC.
  - A PC restart (Technically can still be used, but its Sega we're talking about)

*Using other launchers (even a separate copy of this launch script) generates a different token and you'd want to use **ONLY** the latest generated token in order to avoid being flagged by the game server, Just to be safe.*

**Extra Precaution**
 - Although the token can still be used up to several days, It is recommended to generate a new token once per day, for good measure.
 - Clear your token when leaving The PC unattended or if its a shared PC.
