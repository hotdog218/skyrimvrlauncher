@echo off
color b

REM | Set magevrloc to the folder that your MageVR.exe file is located in, set skseloc to your SkyrimVR game exe directory. Do NOT include a closing backslash or quotation marks (even for paths with spaces)
set magevrloc=D:\Mods\SkyrimVR\MageVR
set skseloc=S:\Steam\steamapps\common\SkyrimVR

REM | Set this only if you're using Natural Locomotion.
set natlocoloc=S:\Steam\steamapps\common\Natural Locomotion

if [%magevrloc%] == [] (
	echo Please edit the batch file and enter your MageVR.exe folder location.
	goto dirtyexit
)
if [%skseloc%] == [] (
	echo Please edit the batch file and enter your sksevr_loader.exe folder location.
	goto dirtyexit
)

echo Checking to see if SteamVR is running...
tasklist /FI "IMAGENAME eq vrmonitor.exe" 2>NUL | find /I /N "vrmonitor.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo Done
	echo.
	goto natloco
) else (
	echo Please launch SteamVR!
	goto dirtyexit
)

:natloco
echo Checking to see if Natural Locomotion is running...
tasklist /FI "IMAGENAME eq naturallocomotion.exe" 2>NUL | find /I /N "naturallocomotion.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo Done
	echo.
	goto magevr
) else (
	echo Natural Locomotion is not running.
	set /p UYN="Continue? (y/n)"
	if /I %UYN% EQU "y" goto magevr
	if /I %UYN% EQU "n" (
		echo Quitting...
		goto dirtyexit
	)
)

:magevr
echo Launching MageVR...
start /D "%magevrloc%" "" "%magevrloc%\MageVR.exe"
timeout 5
tasklist /FI "IMAGENAME eq MageVR.exe" 2>NUL | find /I /N "MageVR.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo Done
	echo.
	goto skse
) else (
	echo Failed to launch MageVR.
	goto dirtyexit
)

:skse
echo Launching SKSE...
start /D "%skseloc%" "" "%skseloc%\sksevr_loader.exe"
echo Waiting for Skyrim to start...
timeout 5
goto skyrim

:skyrim
tasklist /FI "IMAGENAME eq SkyrimVR.exe" 2>NUL | find /I /N "SkyrimVR.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo Done
	echo.
	goto cleanexit
) else (
	echo Failed to launch SkyrimVR. Make sure SKSE is installed correctly.
	goto dirtyexit
)

:cleanexit
echo Success!
exit

:dirtyexit
PAUSE
exit