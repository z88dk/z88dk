# Microsoft Developer Studio Project File - Name="containers" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=containers - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "containers.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "containers.mak" CFG="containers - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "containers - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "containers - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "containers - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MD /W3 /GR /GX /O2 /D "WIN32" /D "NDEBUG" /D "_LIB" /D "_MBCS" /c
# ADD CPP /nologo /MD /W3 /GR /GX /O2 /D "WIN32" /D "NDEBUG" /D "_LIB" /D "_MBCS" /c
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "containers - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /GR /GX /Od /D "WIN32" /D "_DEBUG" /D "_LIB" /D "_MBCS" /c
# ADD CPP /nologo /MDd /W3 /GR /GX /Od /D "WIN32" /D "_DEBUG" /D "_LIB" /D "_MBCS" /c
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "containers - Win32 Release"
# Name "containers - Win32 Debug"
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx"
# Begin Source File

SOURCE=..\..\containers\containers.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\containers_fixes.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\copy_functors.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\exceptions.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\safe_iterator.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\triple.hpp
# End Source File
# End Group
# Begin Group "Source Files"

# PROP Default_Filter "c;cpp;cxx"
# End Group
# Begin Group "Template Implementations"

# PROP Default_Filter "tpp;txx"
# Begin Source File

SOURCE=..\..\containers\digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\safe_iterator.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\containers\triple.tpp
# End Source File
# End Group
# End Target
# End Project
