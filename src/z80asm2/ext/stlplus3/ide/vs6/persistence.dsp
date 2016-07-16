# Microsoft Developer Studio Project File - Name="persistence" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=persistence - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "persistence.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "persistence.mak" CFG="persistence - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "persistence - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "persistence - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "persistence - Win32 Release"

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

!ELSEIF  "$(CFG)" == "persistence - Win32 Debug"

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

# Name "persistence - Win32 Release"
# Name "persistence - Win32 Debug"
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx"
# Begin Source File

SOURCE=..\..\persistence\persistence.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistence_fixes.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_basic.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_bitset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_bool.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_callback.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_complex.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_contexts.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_cstring.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_deque.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_enum.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_exceptions.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_float.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_inf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_int.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_interface.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_list.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_map.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_multimap.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_multiset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_pair.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_pointer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_pointers.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_set.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_shortcuts.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_stl.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_stlplus.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_string.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_triple.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_vector.hpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_xref.hpp
# End Source File
# End Group
# Begin Group "Source Files"

# PROP Default_Filter "c;cpp;cxx"
# Begin Source File

SOURCE=..\..\persistence\persistent_bool.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_contexts.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_cstring.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_exceptions.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_float.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_inf.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_int.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_string.cpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_vector.cpp
# End Source File
# End Group
# Begin Group "Template Implementations"

# PROP Default_Filter "tpp;txx"
# Begin Source File

SOURCE=..\..\persistence\persistent_bitset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_callback.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_complex.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_deque.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_enum.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_interface.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_list.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_map.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_multimap.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_multiset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_pair.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_pointer.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_set.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_shortcuts.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_string.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_triple.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_vector.tpp
# End Source File
# Begin Source File

SOURCE=..\..\persistence\persistent_xref.tpp
# End Source File
# End Group
# End Target
# End Project
