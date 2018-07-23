Rem check the type of os so  you can correctly copy in the right directory
:CheckOS
IF EXIST "%PROGRAMFILES(X86)%" (GOTO 64BIT) ELSE (GOTO 32BIT)

:64BIT
cmd /c copy /Y \\File\Location\nxlog.conf "C:\Program Files (x86)\nxlog\conf"
cmd /c copy /Y \\file\Location\ca.crt "C:\Program Files (x86)\nxlog\"
GOTO END

:32BIT
cmd /c copy /Y \\file\Location\nxlog2.conf "C:\Program Files\nxlog\conf\nxlog.conf"
cmd /c copy /Y \\file\Location\ca.crt "C:\Program Files\nxlog\"
GOTO END

:END
@echo off



REM Start nxlog
cmd /c net stop nxlog
cmd /c net start nxlog

netsh advfirewall firewall set rule group="Remote Administration" new enable=yes

copy /y "\\file\Location\shortcut 1.lnk" "d:\%Username%\Desktop\Shortcut 1.lnk"
copy /y "\\file\location\shortcut 2.lnk" "d:\%Username%\Desktop\Shortcut 2.lnk"
copy /y "\\file\location\shortcut 3.lnk" "d:\%Username%\Desktop\Shortcut 3.lnk"

pause
