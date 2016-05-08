:: RevokeChinaCerts Online(Firefox) batch
:: Revoke China Certificates.
:: 
:: Author: Chengr28
:: 

@echo off


:: Locate directory and architecture check
cd /D "%~dp0"
set Certutil="%~dp0Tools\Certutil\certutil.exe"
set Certificates="%~dp0..\Shared\Certificates


:: Check Firefox profiles
set Portable=1
echo RevokeChinaCerts Online(Firefox) batch
echo.
echo Revoke certificates in installed Firefox profile? [Y/N]
echo When you choose N:
echo * Certificates in portable Firefox profile will be revoked.
echo * Enter portable profile path, like "C:\Firefox\Data\profile" without quotes.
echo * The profile directory must include cert8.db database file.
echo.
set /P UserChoice="Choose: "
if /I %UserChoice% EQU Y (set Portable=0)
echo.

:: Check installed Firefox profile
if %Portable% EQU 0 (
	cd /D "%APPDATA%\Mozilla\Firefox\Profiles"
	if ERRORLEVEL 1 (
		echo.
		echo Cannot load any installed Firefox profiles!
		echo * Enter portable profile path, like "C:\Firefox\Data\profile" without quotes.
		echo * The profile directory must include cert8.db database file.
		echo.
		set Portable=1
	)
)
if not %Portable% EQU 0 (
	set /P PortablePath="Profile path: "
	echo.
)
if not %Portable% EQU 0 (
	cd /D %PortablePath%
	if ERRORLEVEL 1 (
		echo.
		echo Cannot load any Firefox profiles, please check your configuration.
		echo.
		pause
		exit
	)
)


:: Choice and scan all Firefox profile directories
cls
echo RevokeChinaCerts Online(Firefox) batch
echo.
echo 1: Base version
echo 2: Extended version
echo 3: All version
echo 4: Restore all Online revoking
echo * Make sure that Firefox is not running!
echo.
set /P UserChoice="Choose: "
set UserChoice=CASE_%UserChoice%
if %Portable% EQU 0 (
	dir /A:D-S /B > "%~dp0ProfileList.txt"
)
cls
goto %UserChoice%


:: Support functions
:REVOKE_SCAN
if %Portable% EQU 0 (
	for /F "usebackq tokens=*" %%i in ("%~dp0ProfileList.txt") do call :REVOKE %%i %%1
) else (
	call :REVOKE %1
)
goto :EOF

:REVOKE
if %Portable% EQU 0 (
	cd /D "%APPDATA%\Mozilla\Firefox\Profiles\%~1"
	%Certutil% -d . -A -i %Certificates%\%2.crt" -n %2 -t "p,p,p"
) else (
	cd /D "%PortablePath%"
	%Certutil% -d . -A -i %Certificates%\%1.crt" -n %1 -t "p,p,p"
)
goto :EOF

:RESTORE
if %Portable% EQU 0 (
	del /F "%APPDATA%\Mozilla\Firefox\Profiles\%1\cert8.db"
) else (
	del /F "%PortablePath%\cert8.db"
)
goto :EOF


:: All version
:CASE_3
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.Low.Root.CA.txt") do call :REVOKE_SCAN %%i
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.Low.Intermediate.CA.txt") do call :REVOKE_SCAN %%i
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.Low.SSL.txt") do call :REVOKE_SCAN %%i

:: Extended version
:CASE_2
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.Medium.Root.CA.txt") do call :REVOKE_SCAN %%i
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.Medium.Intermediate.CA.txt") do call :REVOKE_SCAN %%i
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.Medium.SSL.txt") do call :REVOKE_SCAN %%i

:: Base version
:CASE_1
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.High.Root.CA.txt") do call :REVOKE_SCAN %%i
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.High.Intermediate.CA.txt") do call :REVOKE_SCAN %%i
for /F "usebackq tokens=*" %%i in (%Certificates%\Severity.High.SSL.txt") do call :REVOKE_SCAN %%i
goto EXIT

:: Restore version
:CASE_4
if %Portable% EQU 0 (
	for /F "usebackq tokens=*" %%i in ("%~dp0ProfileList.txt") do call :RESTORE %%i
) else (
	call :RESTORE
)


:: Exit
:EXIT
if %Portable% EQU 0 (
	del /F "%~dp0ProfileList.txt"
)
echo.
echo RevokeChinaCerts Online(Firefox) batch
echo Done, please confirm the messages on screen.
echo.
pause
