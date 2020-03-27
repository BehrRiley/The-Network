@Echo Off
cd "..\Servers\1.15.2 Construction"
cls
:VersionCheck
set /P Version="Run Spigot or Paper?:"
:Restart
if %Version%==Spigot goto SpigotCheck
if %Version%==Paper goto PaperCheck
goto BadVar

:SpigotCheck
if exist "..\..\.jars\Version\1.15.2 Paper (2).jar" (
    echo [92mUpdate found - updating.[0m
    timeout 1 
    del "..\..\.jars\Version\1.15.2 Paper.jar"
    ren "..\..\.jars\Version\1.15.2 Paper (2).jar" "1.15.2 Paper.jar"
    )
goto %Version%Start

:PaperCheck
if exist "..\..\.jars\Version\1.15.2 Paper (2).jar" (
    echo [92mUpdate found - updating.[0m
    del "..\..\.jars\Version\1.15.2 Paper.jar"
    ren "..\..\.jars\Version\1.15.2 Paper (2).jar" "1.15.2 Paper.jar"
    )
goto %Version%Start

:BadVar
echo [93m%Version%[0m [91mis an invalid Version.[0m
echo [91mPlease type one of the valid versions:[0m
echo [91m[ PAPER ] or [ SPIGOT ][0m
goto VersionCheck

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