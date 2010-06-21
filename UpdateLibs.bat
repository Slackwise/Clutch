@echo off

SET Source="C:\Users\Slackwise\Source\Ace3"
SET Dest="C:\Program Files (x86)\World of Warcraft\Interface\AddOns\Clutch\Libs"

TortoiseProc /command:update /path:%Source%

xcopy %Source%\LibStub %Dest%\LibStub /Y
xcopy %Source%\AceDB-3.0 %Dest%\AceDB-3.0 /Y
xcopy %Source%\AceConfig-3.0 %Dest%\AceConfig-3.0 /Y

pause
