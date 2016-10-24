@echo off

setlocal
setlocal ENABLEDELAYEDEXPANSION

echo.
echo WINMAKE: GENERATING HEADER FILES
echo.

for /R proto %%h in (*.h) do (

   echo %%h
   
   set src=%%h
   set dst=!src:proto=sccz80!
   m4 -Dm4_SCCZ80 "%%h" > "!dst!"
   
   set src=%%h
   set dst=!src:proto=sdcc!
   m4 -Dm4_SDCC "%%h" > "!dst!"
   
   set src=%%h
   set dst=!src:proto=clang!
   m4 -Dm4_CLANG "%%h" > "!dst!"

   echo.
)
