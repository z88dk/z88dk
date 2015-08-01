@echo off

setlocal
setlocal ENABLEDELAYEDEXPANSION

echo.
echo WINLIST: LISTING ALL FUNCTIONS
echo.

del list.txt

for /R proto %%h in (*.h) do (

   echo %%h
   
   set src=%%h
   m4 "%%h" | grep ";;;;;;" >> list.txt

   echo.
)
