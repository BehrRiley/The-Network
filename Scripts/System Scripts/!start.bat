@echo off

echo Opening Gateway Server
timeout 3 /nobreak
start cmd /k call !start_1152gateway.bat

REM echo Starting Database Server
REM timeout 3 /nobreak
REM start cmd /k call !start_datahost.bat

echo Starting Main Server
timeout 3 /nobreak
start cmd /k call !start_1152production.bat


echo Initiating Backup System
timeout 3 /nobreak
call .save_all.bat
pause