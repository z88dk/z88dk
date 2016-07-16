# Microsoft Developer Studio Project File - Name="strings" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=strings - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "strings.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "strings.mak" CFG="strings - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "strings - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "strings - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "strings - Win32 Release"

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
# ADD CPP /nologo /MD /W3 /GR /GX /O2 /I "..\..\portability" /I "..\..\containers" /D "WIN32" /D "NDEBUG" /D "_LIB" /D "_MBCS" /c
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "strings - Win32 Debug"

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
# ADD CPP /nologo /MDd /W3 /GR /GX /Od /I "..\..\portability" /I "..\..\containers" /D "WIN32" /D "_DEBUG" /D "_LIB" /D "_MBCS" /c
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

# Name "strings - Win32 Release"
# Name "strings - Win32 Debug"
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx"
# Begin Source File

SOURCE=..\..\strings\format_types.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_basic.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_bitset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_bool.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_cstring.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_float.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_inf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_int.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_list.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_map.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_pair.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_pointer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_sequence.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_set.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_stl.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_stlplus.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_string.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_triple.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_vector.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_basic.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_bitset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_bool.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_cstring.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_float.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_inf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_int.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_list.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_map.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_pair.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_pointer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_sequence.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_set.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_stl.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_stlplus.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_string.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_triple.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_utilities.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_vector.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\strings.hpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\strings_fixes.hpp
# End Source File
# End Group
# Begin Group "Source Files"

# PROP Default_Filter "c;cpp;cxx"
# Begin Source File

SOURCE=..\..\strings\print_bool.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_cstring.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_float.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_inf.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_int.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_string.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_vector.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_bool.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_cstring.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_float.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_inf.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_int.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_string.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_utilities.cpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_vector.cpp
# End Source File
# End Group
# Begin Group "Template Implementations"

# PROP Default_Filter "tpp;txx"
# Begin Source File

SOURCE=..\..\strings\print_bitset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_list.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_map.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_pair.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_pointer.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_sequence.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_set.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_triple.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\print_vector.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_bitset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_list.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_map.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_pair.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_pointer.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_sequence.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_set.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_triple.tpp
# End Source File
# Begin Source File

SOURCE=..\..\strings\string_vector.tpp
# End Source File
# End Group
# End Target
# End Project
