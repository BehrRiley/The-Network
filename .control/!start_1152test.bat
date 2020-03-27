:begin
cd "..\Servers\1.15.2 Test"

java -Xms1G -Xmx1G -jar paper-145.jar -nogui

timeout 3
echo resuming server...
goto begin