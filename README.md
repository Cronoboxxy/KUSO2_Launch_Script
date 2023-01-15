# KUSO2 Launch Script
Fast, simple launch script for PSO2NGS.
Originally made just to quickly run PSO2NGS after crashing without relogging in again, this method bypasses the need to launch tweaker or the official launcher for PSO2NGSJP to run, and instead makes use of a fork of the [PSO2JP_Token_Generator](https://github.com/Cronoboxxy/PSO2JP_Token_Generator) as part of a batch script when run:
 - Starts the game quickly.
 - Loads the token generator and launch the game quickly.
 - Reuse the token quickly when needed.
 - Clear your token quickly when needed.
 - Clears your token after a set time (By default is 1 day).

This is just a simple launch script to run the game that assumes that you have an up to date version of the game installed and does not do anything beyond the ones listed above.
You will still need the Tweaker or the original launcher to update the game.

For your account safety, you MUST generate a new token after:
 - A PC restart
 - Gameserver maintenance
 - Logging in the game using another launcher, and/or logging in on another PC.

Using other launchers (even a separate copy of this launch script) generates a different token and you'd want to use ONLY the latest generated token in order to avoid being flagged by the game server, Just to be safe.

Safety precaution
 - It is recommended to generate a new token once per day, for good measure.
 - Clear your token when leaving The PC unattended or if its a shared PC.

Now thats out of the way, if you want, you can grab and use a working copy of the script by going to [Release](https://github.com/Cronoboxxy/KUSO2_Launch_Script/releases),
and extracting the content to your 'pso2_bin' folder, where your pso2.exe is located and running 'kuso2auth.bat' (You can then place a shortcut of this script anywhere and/or edit it however you wish).