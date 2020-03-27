:begin
cd "..\Servers\1.12.2 Construction"

REM PAPER START
REM java -Xms1G -Xmx1G -jar paper-1618.jar

REM SPIGOT START
java -Xms1G -Xmx1G -jar spigot-1.12.2.jar

timeout 3
echo resuming server...
goto begin