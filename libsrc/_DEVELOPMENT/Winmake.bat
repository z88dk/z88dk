@echo off

setlocal
setlocal ENABLEDELAYEDEXPANSION

@rem must have leading and trailing space

set alltargets= z80 cpm m rc2014 sms z180 zx 

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

      m4 -DCFG_ASM_DEF target/%%t/config.m4 > target/%%t/config_%%t_private.inc
      m4 -DCFG_ASM_PUB target/%%t/config.m4 > target/%%t/config_%%t_public.inc
      m4 -DCFG_C_DEF target/%%t/config.m4 > target/%%t/config_%%t.h

      copy /Y target\%%t\config_%%t_private.inc config_private.inc 1> nul

      if "%%t" == "zx" (
         zcc +z80 -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_48.bin
         zcc +z80 -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_p3.bin
         zx7 -f arch/zx/bifrost2/z80/bifrost2_engine_48.bin
         zx7 -f arch/zx/bifrost2/z80/bifrost2_engine_p3.bin
      )

      if exist target\%%t\library\%%t_macro.lst (
         echo   %%t_macro.m4
         zcc +z80 -vn -clib=new -m4 --lstcwd @target/%%t/library/%%t_macro.lst
      )

      echo   %%t_sccz80.lib
      
      z80asm -x%%t_sccz80 -D__SCCZ80 @target/%%t/library/%%t_sccz80.lst
      move /Y %%t_sccz80.lib lib/sccz80/%%t.lib

      del /S *.o > nul 2>&1
      del /S *.err > nul 2>&1

      echo   %%t_sdcc_ix.lib

      z80asm -x%%t_sdcc_ix -D__SDCC -D__SDCC_IX @target/%%t/library/%%t_sdcc_ix.lst
      move /Y %%t_sdcc_ix.lib lib/sdcc_ix/%%t.lib

      del /S *.o > nul 2>&1
      del /S *.err > nul 2>&1

      echo   %%t_sdcc_iy.lib

      z80asm --IXIY -x%%t_sdcc_iy -D__SDCC -D__SDCC_IY @target/%%t/library/%%t_sdcc_iy.lst
      move /Y %%t_sdcc_iy.lib lib/sdcc_iy/%%t.lib

      del /S *.o > nul 2>&1
      del /S *.err > nul 2>&1
      
      del config_private.inc > nul 2>&1
      del zcc_opt.def > nul 2>&1

   ) else (

      echo.
      echo target %%t unknown
   
   )
)

echo.

