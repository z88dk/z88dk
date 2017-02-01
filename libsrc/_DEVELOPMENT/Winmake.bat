@echo off

setlocal
setlocal ENABLEDELAYEDEXPANSION

@rem must have leading and trailing space

set alltargets= embedded cpm m rc2014 sms z180 zx 

if "%1" == "" (
   echo.
   echo WINMAKE: GENERATE Z80 LIBRARIES
   echo Usage: Winmake target
   echo.
   echo target=
   echo   all

   for %%t in (%alltargets%) do echo   %%t
   
   echo.
   exit /b
)

if "%1" == "all" (
   set targets=%alltargets%
) else (
   set targets=%*
)

echo.
echo WINMAKE: GENERATING Z80 LIBRARIES

for %%t in (%targets%) do (

   set temp=!alltargets: %%t =!

   if not "!temp!" == "%alltargets%" (
   
      echo.
      echo target = %%t

      copy /Y target\%%t\clib_cfg.asm . 1> nul
      copy /Y target\%%t\clib_target_cfg.asm . 1> nul

      echo   %%t_sccz80.lib
      
      zcc +embedded -vn -clib=new --lstcwd -x @target/%%t/library/%%t_sccz80.lst -o %%t_sccz80
      move /Y %%t_sccz80.lib lib/sccz80/%%t.lib

      del /S *.o > nul 2>&1
      del /S *.err > nul 2>&1

      echo   %%t_sdcc_ix.lib

      zcc +embedded -vn -clib=sdcc_ix --lstcwd -x @target/%%t/library/%%t_sdcc_ix.lst -o %%t_sdcc_ix
      move /Y %%t_sdcc_ix.lib lib/sdcc_ix/%%t.lib

      del /S *.o > nul 2>&1
      del /S *.err > nul 2>&1

      echo   %%t_sdcc_iy.lib

      zcc +embedded -vn -clib=sdcc_iy --lstcwd -Ca--IXIY -x @target/%%t/library/%%t_sdcc_iy.lst -o %%t_sdcc_iy
      move /Y %%t_sdcc_iy.lib lib/sdcc_iy/%%t.lib

      del /S *.o > nul 2>&1
      del /S *.err > nul 2>&1
      
      del clib_cfg.asm > nul 2>&1
      del clib_target_cfg.asm > nul 2>&1
      
   ) else (

      echo.
      echo target %%t unknown
   
   )
)

echo.

