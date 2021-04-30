@ECHO OFF
SET Z88DK_DIR=%~dp0
IF NOT "%ZCCCFG%"=="" GOTO go_without_settings
SET ZCCCFG=%Z88DK_DIR%lib\config\
SET PATH=%Z88DK_DIR%bin;%PATH%
:go_without_settings

ECHO This prompt includes z88dk commands in the PATH.
ECHO The environment variable ZCCCFG is set properly.
ECHO.
CMD /k
