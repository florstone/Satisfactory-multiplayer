# Satisfactory-multiplayer

This script is inpired by https://github.com/patrix87/SatisfactorySync

## What it does : 

This script will allow you to share and manage a save file between you and your friends without the risk of overwriting your save.

## What you need : 

- A shared cloud folder with write access with your friends like Nextcloud.
- The cloud desktop application to sync the folder.
- Some very basic skills in scripting *(changing paths in variables)
- PowerShell *(included in Windows 10)
- EpicGame version of Satisfactory

## How to configure it : 

- Past the repository directly in your cloud synced folder 
- Each user should then copy the content of the script folder somewhere on their computer.
- Once you have your own copy of the script folder you must adjust the different paths and variables to match your local configuration. *(Details in FactoryMultiplayer.ps1 script itself.)*
- To find your Epic IP please follow this procedure: https://www.epicgames.com/help/en-US/epic-accounts-c74/general-support-c79/what-is-an-epic-account-id-and-where-can-i-find-it-a3659
- Disable cloud save in the Epic Games Launcher.
- Start a new game or save an existing game with the name **SharedGame**

## How to use it : 

- Run FactoryMultiplayerLauncher.ps1, it will check if you are the first to play on the save, lock the file and launch the game.
- Load the **SharedGame** save file.
- Other players will then join you.
- Before you leave, save the game with the name **SharedGame** and overwrite the previous save with that name.
- Type 'exit', the script will sync the most up to date version to the cloud.
- The next person to host the game should then wait for the save to sync and run the script on their end to update their local file.

## DISCLAIMER !

Since this script was meant to be used only by me I do not take any responsibility for anything that happens because of it.
Powershell is not my main language if you see inconsistencies or optimizations to do do not hesitate to open an issue.

## Thanks and acknowledgements

- [patrix87](https://github.com/patrix87) for his script.
- [Nexioh](https://twitter.com/Nexioh) For his help and advices.

### Security consideration 

Understand that running a cloud hosted PowerShell script on your local computer represent a major security risk. If anyone modify the script they could easily break your computer or way worse. Always copy the script locally and verify it before your run it for the first time. Note that the 7zip files could also be tempered with so you might as well make your own local copy of them to avoid that. *you'll have to edit your copy of the script to match the paths*
