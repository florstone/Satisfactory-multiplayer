
#---------------------------------------------------------
# Variables
#---------------------------------------------------------

# Variables you should change.
$cloudPath="C:\YOUR\CLOUD\PATH\"																											#Folder path synchronized with your Cloud																									#
$EpicID="abcd1234"																															#EpicGame ID,  	
$Gamepath="C:\Program Files\Epic Games\SatisfactoryEarlyAccess\FactoryGame.exe"																#Game path	
$clientName=${env:UserName}																													#Your name. formating : "nickname" OR ${env:UserName} for the environment variable.


#Variables you should probably not change.												
$localSave="C:\Users\"+${env:UserName}+"\AppData\Local\FactoryGame\Saved\SaveGames\$EpicID\SharedGame.sav"								    #Path to the local save FILE, Don't forget to edit the part for the ID folder that look like this : 289339e8e418470095a90ceeca947834
$cloudSave=$cloudPath+"\SharedGame\SharedGame.sav"																							#Path to the cloud save FILE
$backupPath=$cloudPath+"\Backups"																											#Path to the cloud backups FOLDER
$backupDays="14"																															#Number of days of backups to keep.
$7zExec=$cloudPath+"\7z\7za.exe"																											#Path to 7zip




#Do not modify below this line
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#



#---------------------------------------------------------
#Lock file
#---------------------------------------------------------
Write-Host "Checking lock File"

$checklock = Test-Path $cloudPath"\lock.lck"
#Check if a lock file is present
If ($checklock -eq $True)
 {
 $userlock = Get-Content $cloudPath"\lock.lck"
 Write-Host "Save already in use, join your friend"$userlock" directly" -ForegroundColor red -BackgroundColor white
	Write-Host "Press a key to exit"
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
	exit
}

Else {
#Creation of the lock file if absent
Write-Host "Lock file creation" -ForegroundColor red -BackgroundColor white
new-item $cloudPath"\lock.lck" -type file -force  
Set-Content -Path $cloudPath"\lock.lck" -Value $clientName
}


#---------------------------------------------------------
#Config Check
#---------------------------------------------------------
Write-Host "Checking config"

if (!(Test-Path $7zExec)){
	Write-Host "7za.exe not found at : $7zExec"wa
	pause
	exit
}

#---------------------------------------------------------
#Backup
#---------------------------------------------------------

Write-Host "Check if a backup is necessary"
#Create backup name from date and time
$backupDate=Get-Date -UFormat %Y-%m-%d_%H-%M-%S

#Compare both save file

$clientFileDate = [datetime](Get-ItemProperty -Path $localSave -Name LastWriteTime).lastwritetime 
$cloudFileDate = [datetime](Get-ItemProperty -Path $cloudSave -Name LastWriteTime).lastwritetime 

if ($clientFileDate -eq $cloudFileDate){
	Write-Host "Both file are the same age, skiping process"
} else {
	#if client file is more recent, backup the cloud file and copy the client file to the cloud
	if ($clientFileDate -gt $cloudFileDate) {
		$backupName=$backupDate+" Cloud"
		Write-Host "Using Client File"
		New-Item -ItemType directory -Path $backupPath -ErrorAction SilentlyContinue
		& $7zExec a -tzip -mx=1 $backupPath\$backupName.zip $cloudSave
		Copy-Item $localSave $cloudSave -Force
		Write-Host "Backup Created : $backupName.zip"
	}

	#if cloud file is more recent, backup the client file and copy the cloud file to the client
	if ($clientFileDate -lt $cloudFileDate) {
		$backupName=$backupDate+" "+$clientName
		Write-Host "Using Cloud File"
		New-Item -ItemType directory -Path $backupPath -ErrorAction SilentlyContinue
		& $7zExec a -tzip -mx=1 $backupPath\$backupName.zip $localSave
		Copy-Item $cloudSave $localSave -Force
		Write-Host "Backup Created : $backupName.zip"
	}

	#Delete old backups
	echo "Deleting backup older than $backupDays"
	$limit = (Get-Date).AddDays(-$backupDays)
	Get-ChildItem -Path $backupPath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit } | Remove-Item -Force
}


#starting the game
Write-Host "Game is starting" -ForegroundColor red -BackgroundColor white
Invoke-Expression $Gamepath
Start-Sleep -s 5

#Wait until exit
Write-Host "To exit, save your game as SharedGame and write exit" -ForegroundColor red -BackgroundColor white
do{ $YesNoResponse = Read-Host "Please write exit"} 
until($YesNoResponse -eq "exit")
Write-Host "Thank you !" -ForegroundColor red -BackgroundColor white
Write-Host "Closing please wait" -ForegroundColor red -BackgroundColor white


#Compare both save file
$clientFileDate = [datetime](Get-ItemProperty -Path $localSave -Name LastWriteTime).lastwritetime
$cloudFileDate = [datetime](Get-ItemProperty -Path $cloudSave -Name LastWriteTime).lastwritetime
if ($clientFileDate -eq $cloudFileDate){
	Write-Host "Both file are the same age, skiping process"
} else {
	#if client file is more recent, backup the cloud file and copy the client file to the cloud
	if ($clientFileDate -gt $cloudFileDate) {
		$backupName=$backupDate+" Cloud"
		$backupName=$backupDate+" Cloud"
		Write-Host "Using Client File"
		New-Item -ItemType directory -Path $backupPath -ErrorAction SilentlyContinue
		& $7zExec a -tzip -mx=1 $backupPath\$backupName.zip $cloudSave
		Copy-Item $localSave $cloudSave -Force
		Write-Host "Backup Created : $backupName.zip"
	}

	#if cloud file is more recent, backup the client file and copy the cloud file to the client
	if ($clientFileDate -lt $cloudFileDate) {
		$backupName=$backupDate+" "+$clientName
		Write-Host "Using Cloud File"
		New-Item -ItemType directory -Path $backupPath -ErrorAction SilentlyContinue
		& $7zExec a -tzip -mx=1 $backupPath\$backupName.zip $localSave
		Copy-Item $cloudSave $localSave -Force
		Write-Host "Backup Created : $backupName.zip"
	}
}
#deleting lock file
Remove-Item -Path $cloudPath"\lock.lck" -include *.lck
Write-Host "Good bye" -ForegroundColor red -BackgroundColor white
Start-Sleep -s 5
exit
