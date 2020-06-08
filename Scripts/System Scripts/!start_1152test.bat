@Echo Off
set /p ID="Type Test Server ID:"
cls
if EXIST "..\Servers\1.15.2 Test%ID%" goto start

:CreateDir
echo [91mServer 1.15.2 Test%ID% does not exist. Creating from template.[0m
xcopy /E /H /R /Y "..\Servers\Templates\1.15.2 Template" "..\Servers\"
ren "..\Servers\1.15.2 Template" “1.15.2 Test%ID%"

:start
cd "..\Servers\1.15.2 Test%ID%"

:VersionCheck
set /P Version="Run Spigot or Paper?:"
:Restart
if %Version%==Spigot goto SpigotStart
if %Version%==Paper goto PaperStart
goto BadVar

:PaperStart
if exist "..\..\.jars\Version\1.15.2 Paper.jar" (
    java -Xms1G -Xmx1G -jar "..\..\.jars\Version\1.15.2 Paper.jar" -nogui
    ) else (
    goto JarNotFound
)
timeout 5
goto Restart

:SpigotStart
if exist "..\..\.jars\Version\1.15.2 Spigot.jar" (
    java -Xms1G -Xmx1G -jar "..\..\.jars\Version\1.15.2 Spigot.jar" -nogui
    ) else (
    goto JarNotFound
)
timeout 5
goto Restart

:JarNotFound
echo [91m%Version% jar file not found.[0m
timeout 30
goto restart