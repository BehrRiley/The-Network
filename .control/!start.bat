:begin
cd "..\1.15.2 Survival"

java -Xms1G -Xmx1G -jar paper-126.jar -nogui

timeout 3
echo resuming server...
goto begin