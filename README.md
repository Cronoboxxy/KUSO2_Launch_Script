# KUSO2 Launcher

![KUSO2 Launcher](https://cdn.discordapp.com/attachments/1113499906104098918/1155679344442757222/image.png)

Originally made just to quickly run PSO2NGS after crashing without relogging in again, this method bypasses the need to launch tweaker or the official launcher for PSO2NGSJP to run and also makes use of the [PSO2JP_Token_Generator](https://github.com/Cronoboxxy/PSO2JP_Token_Generator) as part of a batch script when run:
- Starts the game quickly, with or without token login.
- Loads the token generator and launches the game quickly.
- Reuses the token and starts the game quickly when needed.
- Option to clear your token when needed.
- Clears your token after a set time (default is 1 day; editable in config).

*This is just a simple launch script to run the game that assumes that you have an up-to-date version of the game installed and does not do anything beyond the ones listed above. This script is also only intended to work for the JP version of the game.*

**You will still need the Tweaker or the official launcher to update the game.**

You can grab and use a working copy of the script by going to the [Release](https://github.com/Cronoboxxy/KUSO2_Launch_Script/releases) section and place it anywhere you want. It will ask for the game path on the first run or when it can't detect the game.

You can also grab the script directly in [this repo](https://github.com/Cronoboxxy/KUSO2_Launch_Script/tree/main/ks2_bin) and edit to your liking and build the token generator from [source](https://github.com/Cronoboxxy/PSO2JP_Token_Generator).

# Account Safety Warning

For your account safety, you **MUST** generate a new token after:
- Gameserver maintenance
- Logging in the game using another launcher, and/or logging in on another PC.
- A PC restart (technically can still be used, but it's Sega we're talking about).

*Using other launchers (even a separate copy of this launch script) generates a different token, and you'd want to use **ONLY** the latest generated token to avoid being flagged by the game server, just to be safe.*

**Extra Precaution**

- Although the token can still be used for up to several days, it is recommended to generate a new token once per day for good measure.
- Clear your token when leaving the PC unattended or if it's a shared PC.
