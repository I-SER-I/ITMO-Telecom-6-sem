@echo off

setlocal EnableDelayedExpansion

echo Avaliable interfaces:
set /A index=1
for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') do (
    echo !index!. %%J
    set "interfaces[!index!]=%%J"
    set /A index+=1
)

set /P interfaceIndex=Choose interface number: 
set interface=!interfaces[%interfaceIndex%]!

set /P mode=Select mode[auto/static]: 

if "%mode%" EQU "auto" (
    netsh interface ipv4 set dns "%interface%" dhcp
    netsh interface ipv4 set address "%interface%" dhcp
)

if "%mode%" EQU "static" (
	set /p ip=Enter IP: 
	set /p mask=Enter mask: 
	set /p gateway=Enter gateway: 
	set /p dns=Enter dns: 

	netsh interface ipv4 set address "%interface%" static !ip! !mask! !gateway!
	netsh interface ipv4 set dns "%interface%" static !dns!
)