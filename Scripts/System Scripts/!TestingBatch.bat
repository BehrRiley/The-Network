@Echo Off
cd "..\Servers\1.15.2 Production"
cls
:VersionCheck
set /P Version="[93mRun[0m [32m([0m[33m0[0m[32m)[0m[92mPaper[0m [93mor[0m [32m([0m[33m1[0m[32m)[0m[92mSpigot[0m[33m?:[97m"
:Restart
if %Version%==Spigot goto Update
if %Version%==Paper goto Update
if %Version%==0 (
    set Version=Paper
    goto Update
    )
if %Version%==1 (
    set Version=Spigot
    goto Update
    )
goto BadVar

:BadVar
echo [93m%Version%[97m [91mis an invalid Version.[97m
echo [91mPlease type one of the valid versions:[97m
echo [31m[ [33m0 [31m/ [91mPAPER [31m]  [33m-[93mor[3m-  [31m[ [33m1 [31m/ [91mSPIGOT [31m]
goto VersionCheck

:Update
for /F %%f in ('dir /b "..\..\.jars\Version\1.15.2 %Version%\Update\*"') do (
    echo [92m[ [93mUpdate Version [92m] Update Found, Starting [ [33m1 [92m/ [33m4 [92m][97m
    if exist "..\..\.jars\Version\1.15.2 %Version%\1.15.2 %Version%.jar" del  "..\..\.jars\Version\1.15.2 %Version%\1.15.2 %Version%.jar"
    copy "..\..\.jars\Version\1.15.2 %Version%\Update\%%f" "..\..\.jars\Version\1.15.2 %Version%\"
    ren  "..\..\.jars\Version\1.15.2 %Version%\%%f" "1.15.2 %Version%.jar"

    echo [92m[ [93mUpdate Version [92m] Updating Cache         [ [33m2 [92m/ [33m4 [92m][97m
    if exist ".jars\Version\.cache\Production\1.15.2 %Version%.jar" del ".jars\Version\.cache\Production\1.15.2 %Version%.jar"
    copy "..\..\.jars\Version\1.15.2 %Version%\Update\%%f" "..\..\.jars\Version\.cache\Production\"
    ren  "..\..\.jars\Version\.cache\Production\%%f" "1.15.2 %Version%.jar"

    echo [92m[ [93mUpdate Version [92m] Cleaning up            [ [33m3 [92m/ [33m4 [92m][97m
    del  "..\..\.jars\Version\1.15.2 %Version%\Update\%%f"

    echo [92m[ [93mUpdate Version [92m]                        [ [33m4 [92m/ [33m4 [92m][97m
    )
goto Run

:Run
if exist "..\..\.jars\Version\.cache\Production\1.15.2 %Version%.jar" (
    echo [92m[ [93mStart Server [92m][97m
    java -Xms1G -Xmx1G -jar "..\..\.jars\Version\.cache\Production\1.15.2 %Version%.jar" -nogui
    ) else (
    goto JarNotFound
)
goto restart

:JarNotFound
echo [91m%Version% jar file not found.[97m
timeout 30
goto restart