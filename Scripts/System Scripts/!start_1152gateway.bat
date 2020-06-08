@Echo Off
cd "..\Servers\1.15.2 Gateway"
cls
:VersionCheck
set /P Version="Run Bungeecord or Waterfall?:"
:Restart
if %Version%==Bungeecord goto BungeecordCheck
if %Version%==Waterfall goto WaterfallCheck
goto BadVar

:BungeecordCheck
if exist "..\..\.jars\Version\Waterfall (2).jar" (
    echo [92mUpdate found - updating.[0m
    timeout 1 
    del "..\..\.jars\Version\Waterfall.jar"
    ren "..\..\.jars\Version\Waterfall (2).jar" "Waterfall.jar"
    )
goto %Version%Start

:WaterfallCheck
if exist "..\..\.jars\Version\Waterfall (2).jar" (
    echo [92mUpdate found - updating.[0m
    del "..\..\.jars\Version\Waterfall.jar"
    ren "..\..\.jars\Version\Waterfall (2).jar" "Waterfall.jar"
    )
goto %Version%Start

:BadVar
echo [93m%Version%[0m [91mis an invalid Version.[0m
echo [91mPlease type one of the valid versions:[0m
echo [91m[ Waterfall ] or [ Bungeecord ][0m
goto VersionCheck

:WaterfallStart
if exist "..\..\.jars\Version\Waterfall.jar" (
    java -Xms1G -Xmx1G -jar "..\..\.jars\Version\Waterfall.jar"
    ) else (
    goto JarNotFound
)
timeout 5
goto Restart

:BungeecordStart
if exist "..\..\.jars\Version\Bungeecord.jar" (
    java -Xms1G -Xmx1G -jar "..\..\.jars\Version\Bungeecord.jar"
    ) else (
    goto JarNotFound
)
timeout 5
goto Restart

:JarNotFound
echo [91m%Version% jar file not found.[0m
timeout 30
goto restart