:begin
@echo off

REM --xcopy--
REM xcopy "from" "to/backup"
REM /W Prompts you to press a key before copying.
REM /E Copies directories and subdirectories, including empty ones.
REM /H Copies hidden and system files
REM /R Overwrites read-only files
REM /Y Suppresses prompting to confirm you want to overwrite an existing destination file.
REM Note:
REM /B Copies the Symbolic Link itself versus the target of the link.

REM --dir--
REM 1.15.2 Production Servers    |  ..\Servers\1.15.2 Production
REM 1.15.2 Construction Servers  |  ..\Servers\1.15.2 Construction
REM 1.15.2 Construction Servers  |  ..\Servers\1.12.2 Construction
REM Data Servers                 |  ..\Servers\0.0.0 Data
REM Backups                      |  ..\.backups\*time

REM - 1.15.2 Production Servers
rd /s /q "..\.backups\1.15.2 Production\96h"
move /Y “..\.backups\1.15.2 Production\84_backup” “..\.backups\1.15.2 Production\96h_backup”
move /Y “..\.backups\1.15.2 Production\72_backup” “..\.backups\1.15.2 Production\84h_backup”
move /Y “..\.backups\1.15.2 Production\60_backup” “..\.backups\1.15.2 Production\72h_backup”
move /Y “..\.backups\1.15.2 Production\48_backup” “..\.backups\1.15.2 Production\60h_backup”
move /Y “..\.backups\1.15.2 Production\36_backup” “..\.backups\1.15.2 Production\48h_backup”
move /Y “..\.backups\1.15.2 Production\24_backup” “..\.backups\1.15.2 Production\36h_backup”
move /Y “..\.backups\1.15.2 Production\12_backup” “..\.backups\1.15.2 Production\24h_backup”
xcopy /W /E /H /R /Y “..\Servers\1.15.2 Production\” “..\.backups\1.15.2 Production\12h_backup”

for /F "tokens=2" %%i in ('date /t') do set mydate=%%i
set mytime=%time%
echo --------------------------------------------------
echo ----- Completion: %mydate%    %mytime% ------
echo --------------------------------------------------
echo --------------------------------------------------
echo ----- Loop Complete ------------------------------
echo --------------------------------------------------
timeout 43200
goto begin
