@setlocal
@set VCVERS=14
@set TMPDRV=X:
@set DOINST=0
@set TMPPRJ=regex
@set TMPLOG=bldlog-1.txt
@set BUILD_RELDBG=0
@set TMPSRC=%TMPDRV%\regex-fork
@echo Build of '%TMPPRJ% in 64-bits 
@if NOT EXIST %TMPDRV%\nul goto NOXDIR
@set TMP3RD=%TMPDRV%\3rdParty.x64
@set CONTONERR=0
@set DOPAUSE=pause
@if "%~1x" == "NOPAUSEx" @set DOPAUSE=echo NO PAUSE requested

@REM ############################################
@REM NOTE: MSVC 10...14 INSTALL LOCATION
@REM Adjust to suit your environment
@REM ##########################################
@set GENERATOR=Visual Studio %VCVERS% Win64
@set VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio %VCVERS%.0
@set VC_BAT=%VS_PATH%\VC\vcvarsall.bat
@if NOT EXIST "%VS_PATH%" goto NOVS
@if NOT EXIST "%VC_BAT%" goto NOBAT
@set BUILD_BITS=%PROCESSOR_ARCHITECTURE%
@IF /i %BUILD_BITS% EQU x86_amd64 (
    @set "RDPARTY_ARCH=x64"
) ELSE (
    @IF /i %BUILD_BITS% EQU amd64 (
        @set "RDPARTY_ARCH=x64"
    ) ELSE (
        @echo Appears system is NOT 'x86_amd64', nor 'amd64'
        @echo Can NOT build the 64-bit version! Aborting
        @exit /b 1
    )
)

@ECHO Setting environment - CALL "%VC_BAT%" %BUILD_BITS%
@CALL "%VC_BAT%" %BUILD_BITS%
@if ERRORLEVEL 1 goto NOSETUP

@set TMPINST=%TMP3RD%

@set TMPOPTS=
@REM set TMPOPTS=%TMPOPTS% -DCMAKE_INSTALL_PREFIX:PATH=%TMPINST%
@set TMPOPTS=%TMPOPTS% -G "%GENERATOR%"

@REM To help find Qt5

@call chkmsvc %TMPPRJ%
@REM Setup Qt5 - 64-bit
@REM call setupqt5.6
@REM if EXIST tempsp.bat @del tempsp.bat
@REM call setupqt564
@REM if NOT EXIST tempsp.bat goto NOSP
@REM call tempsp

@REM Conform to msvclog.pl expected output..
@echo Building %TMPPRJ% 64-bits... all ouput to %TMPLOG%

@REM A 64-bit build of regex
@set INSTALL_DIR=%TMPDRV%\install\msvc140-64\%TMPPRJ%
@REM set SIMGEAR_DIR=%TMPDRV%\install\msvc140-64\SimGear
@REM set OSG_DIR=%TMPDRV%\install\msvc140-64\OpenSceneGraph
@REM set BOOST_ROOT=C:\local\boost_1_62_0
@REM set BOOST_ROOT=C:\local\boost_1_61_0
@REM set BOOST_ROOT=%TMPDRV%\boost_1_60_0
@REM set BOOST_LIBRARYDIR=%BOOST_ROOT%\lib64-msvc-14.0
@REM set ZLIBDIR=%TMP3RD%
@REM set GDAL_INSTALL=Z:\software.x64
@REM if NOT EXIST %GDAL_INSTALL%\nul goto NOGDAL
@REM if NOT EXIST %GDAL_INSTALL%\include\gdal.h goto NOGDAL2
@REM set CGAL_INSTALL=F:\Projects\install\msvc140-64\CGAL
@REM if NOT EXIST %CGAL_INSTALL%\nul goto NOCGAL

@REM if NOT EXIST %SIMGEAR_DIR%\nul goto NOSGD
@REM if NOT EXIST %ZLIBDIR%\nul goto NOZLD
@REM if NOT EXIST %BOOST_ROOT%\nul goto NOBOOST
@REM if NOT EXIST %BOOST_LIBRARYDIR%\nul goto NOBOOST2
@REM set PostgreSQL_ROOT=C:\Program Files (x86)\PostgreSQL\9.1
@REM set LIB=%BOOST_LIBRARYDIR%;%LIB%
@REM if NOT EXIST %SIMGEAR_DIR%\nul goto NOSGD
@REM if "%Qt5_DIR%x" == "x" NOQTD
@rem if NOT EXIST %Qt5_DIR%\nul goto NOQTD
@REM if NOT EXIST %ZLIBDIR%\nul goto NOZLD
@REM echo Set SIMGEAR_DIR=%SIMGEAR_DIR%
@REM echo Set QT5_DIR=%Qt5_DIR%
@REM echo Set ZLIBDIR=%ZLIBDIR%
@REM echo Set OSG_DIR=%OSG_DIR%
@REM echo Set BOOST_ROOT=%BOOST_ROOT%
@REM echo Set BOOST_LIBRARYDIR=%BOOST_LIBRARYDIR%

@set CMOPTS=%TMPOPTS%
@set CMOPTS=%CMOPTS% -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR%
@REM set CMOPTS=%CMOPTS% -DCMAKE_PREFIX_PATH:PATH=%GDAL_INSTALL%;%ZLIBDIR%;%OSG_DIR%;%SIMGEAR_DIR%;%CGAL_INSTALL%
@REM set CMOPTS=%CMOPTS% -DCMAKE_PREFIX_PATH:PATH=%ZLIBDIR%;%OSG_DIR%;%SIMGEAR_DIR%
@REM set CMOPTS=%CMOPTS% -DZLIB_ROOT=%ZLIBDIR%
@REM set CMOPTS=%CMOPTS% -DMSVC_3RDPARTY_ROOT=%TMP3RD%
@REM set CMOPTS=%CMOPTS% -DBOOST_ROOT=%BOOST_ROOT%
@REM set CMOPTS=%CMOPTS% -DBoost_ADDITIONAL_VERSIONS="1.62.0"
@REM set CMOPTS=%CMOPTS% -DBUILD_LIBPROJ_SHARED:BOOL=ON

@REM Conform to std build-me.bat initial output
@echo Building %TMPPRJ% begin %DATE% %TIME% > %TMPLOG%

@echo Doing: 'cmake %TMPSRC% %CMOPTS%'
@echo.
@%DOPAUSE%

@echo Doing: 'cmake %TMPSRC% %CMOPTS%'
@echo Doing: 'cmake %TMPSRC% %CMOPTS% >> %TMPLOG%
@cmake %TMPSRC% %CMOPTS% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR1
@set TMPBLDS=

@echo Doing: 'cmake --build . --config Debug'
@echo Doing: 'cmake --build . --config Debug' >> %TMPLOG%
@cmake --build . --config Debug >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR2
@set TMPBLDS=%TMPBLDS% Debug

:DNDBGBLD
@if "%BUILD_RELDBG%x" == "0x" goto DNRELDBG
@echo Doing: 'cmake --build . --config RelWithDebInfo'
@echo Doing: 'cmake --build . --config RelWithDebInfo' >> %TMPLOG%
@cmake --build . --config RelWithDebInfo >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR3
@set TMPBLDS=%TMPBLDS% RelWithDebInfo

:DNRELDBG
@echo Doing: 'cmake --build . --config Release'
@echo Doing: 'cmake --build . --config Release' >> %TMPLOG%
@cmake --build . --config Release >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR4
@set TMPBLDS=%TMPBLDS% Release

@echo Appears successful build of %TMPBLDS%...

@if "%DOINST%x" == "1x" goto ADDINST
@echo.
@echo Install is disabled, to %INSTALL_DIR%.... Set DOINST=1
@echo.
@goto END

:ADDINST
@echo.
@echo ######## INSTALL %TMPPRJ% ########
@REM echo Will install Release only...
@echo.
@%DOPAUSE%

@echo Doing: 'cmake --build . --config Debug --target INSTALL'
@echo Doing: 'cmake --build . --config Debug --target INSTALL' >> %TMPLOG%
@cmake --build . --config Debug --target INSTALL >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR6

@echo Doing: 'cmake --build . --config Release --target INSTALL'
@echo Doing: 'cmake --build . --config Release --target INSTALL' >> %TMPLOG%
@cmake --build . --config Release --target INSTALL >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR5

@fa4 " -- " %TMPLOG%

@echo.
@echo Done build and install... see %TMPLOG% for details...
@echo.

@goto END

:NOSETUP
@echo MSVC setup FAILED!
@goto ISERR

:NOBAT
@echo Can not locate "%VC_BAT%"! *** FIX ME *** for your environment
@goto ISERR

:NOVS
@echo Can not locate "%VS_PATH%"! *** FIX ME *** for your environment
@goto ISERR

@REM :NOSGD
@echo Note: Simgear directory %SIMGEAR_DIR% does NOT EXIST!  *** FIX ME ***
@goto ISERR

:NOQTD
@echo Note: Qt directory '%Qt5_DIR%' does NOT EXIST! *** FIX ME ***
@goto ISERR

:NOZLD
@echo Note: ZLIB direcotry %ZLIBDIR% does NOT EXIST! *** FIX ME ***
@goto ISERR

:NOBOOST
@echo Note: Boost dir %BOOST_ROOT% does not exist! *** FIX ME ***  
@goto ISERR

:NOBOOST2
@echo Note: Boost dir %BOOST_LIBRARYDIR% does not exist! *** FIX ME ***  
@goto ISERR

:NOCGAL
@echo Note: CGAL dir %CGAL_INSTALL% does not exist! *** FIX ME ***
@goto ISERR 

:NOGDAL
@echo Note: GDAL install dir does NOT EXIST %GDAL_INSTALL%! *** FIX ME *** 
@goto ISERR

:NOGDAL2
@echo Note: GDAL header does NOT EXIST %GDAL_INSTALL%\include\gdal.h! *** FIX ME *** 
@goto ISERR

:NOSP
@echo Failed to generate a tempsp.bat! *** FIX ME ***
@goto ISERR

:ERR1
@echo FATAL ERROR: cmake configuration/generation FAILED
@echo FATAL ERROR: cmake configuration/generation FAILED >> %TMPLOG%
@goto ISERR

:ERR2
@echo ERROR: cmake build Debug
@echo ERROR: cmake build Debug >> %TMPLOG%
@if %CONTONERR% EQU 1 goto DNDBGBLD
@goto ISERR

:ERR3
@echo ERROR: cmake build RelWithDebInfo
@echo ERROR: cmake build RelWithDebInfo >> %TMPLOG%
@if %CONTONERR% EQU 1 goto DNRELDBG
@goto ISERR

:ERR4
@echo ERROR: cmake build Release
@echo ERROR: cmake build Release >> %TMPLOG%
@goto ISERR

:ERR5
@echo ERROR: cmake install rel
@goto ISERR

:ERR6
@echo ERROR: cmake install dbg
@goto ISERR

:NOXDIR
@echo.
@echo Oops, no X: directory found! Needed for simgear, etc
@echo Run setupx, or hdem3m, etc, to establish X: drive
@echo.
@goto ISERR



:ISERR
@endlocal
@exit /b 1

:END
@endlocal
@exit /b 0

@REM eof
