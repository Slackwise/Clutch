@echo off

SET SRC="C:\Users\Slackwise\Source\Ace3"
SET DEST="C:\Program Files (x86)\World of Warcraft\Interface\AddOns\Clutch\Libs"

TortoiseProc /command:update /path:%SRC%

XCOPY %SRC%\LibStub %DEST%\LibStub /Y
XCOPY %SRC%\AceAddon-3.0 %DEST%\AceAddon-3.0 /Y
XCOPY %SRC%\AceConfig-3.0 %DEST%\AceConfig-3.0 /Y  
xcopy %SRC%\AceConsole-3.0 %DEST%\AceConsole-3.0 /Y
XCOPY %SRC%\AceDB-3.0 %DEST%\AceDB-3.0 /Y
XCOPY %SRC%\AceEvent-3.0 %DEST%\AceEvent-3.0 /Y

PAUSE
