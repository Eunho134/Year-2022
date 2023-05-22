@echo off
powershell.exe "& C:\Windows\System32\wsl.exe -u root service apache2 start"
powershell.exe "& C:\Windows\System32\wsl.exe -u root service mariadb start"
powershell.exe "& C:\Windows\System32\wsl.exe -u root service zabbix-server start"
powershell.exe "& C:\Windows\System32\wsl.exe -u root service zabbix-agent start"