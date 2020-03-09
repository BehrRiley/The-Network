:begin
cd "..\Servers\1.15.2 Gateway"

java -Xms1G -Xmx1G -jar waterfall.jar -nogui

timeout 3
echo resuming server...
goto begin