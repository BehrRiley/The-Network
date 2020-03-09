:begin
cd "..\Servers\1.15.2 Production"

java -Xms1G -Xmx1G -jar paper-129.jar -nogui

timeout 3
echo resuming server...
goto begin