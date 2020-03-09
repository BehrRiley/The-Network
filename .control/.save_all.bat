
@echo off

echo ---------------------------------------------------------------------------------------
echo ------------ Starting Backup System ---------------------------------------------------
echo ---------------------------------------------------------------------------------------

timeout 43200 /nobreak
:begin

REM ------------- Directories --------------------------------------------------------------
REM 1.15.2 Production Servers    -  ..\Servers\1.15.2 Production
REM 1.15.2 Construction Servers  -  ..\Servers\1.15.2 Construction
REM 1.15.2 Construction Servers  -  ..\Servers\1.12.2 Construction
REM Data Servers                 -  ..\Servers\0.0.0 Data
REM Backups                      -  ..\.backups\##h\

REM ------------- 1.15.2 Production --------------------------------------------------------
rd /s /q "..\.backups\120h\1.15.2 Production Backup"
move /Y “..\.backups\108h\1.15.2 Production Backup” “..\.backups\120h\”
move /Y “..\.backups\96h\1.15.2 Production Backup” “..\.backups\108h\”
move /Y “..\.backups\84h\1.15.2 Production Backup” “..\.backups\96h\”
move /Y “..\.backups\72h\1.15.2 Production Backup” “..\.backups\84h\”
move /Y “..\.backups\60h\1.15.2 Production Backup” “..\.backups\72h\”
move /Y “..\.backups\48h\1.15.2 Production Backup” “..\.backups\60h\”
move /Y “..\.backups\36h\1.15.2 Production Backup” “..\.backups\48h\”
move /Y “..\.backups\24h\1.15.2 Production Backup” “..\.backups\36h\”
move /Y “..\.backups\12h\” “..\.backups\24h\”
xcopy /E /H /R /Y “..\Servers\1.15.2 Production” “..\.backups\12h\1.15.2 Production Backup\”

REM ------------- Other Placeholder --------------------------------------------------------

for /F "tokens=2" %%i in ('date /t') do set mydate=%%i
set mytime=%time%
echo ---------------------------------------------------------------------------------------
echo ------------ Completion: %mydate%    %mytime% ------------------------------------
echo ---------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------
echo ------------ Loop Complete ------------------------------------------------------------
echo ---------------------------------------------------------------------------------------

timeout 43200 /nobreak
goto begin
