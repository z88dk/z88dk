# Microsoft Developer Studio Project File - Name="stlplus3" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=stlplus3 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "stlplus3_monolithic.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "stlplus3_monolithic.mak" CFG="stlplus3 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "stlplus3 - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "stlplus3 - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "stlplus3 - Win32 Release"

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
# ADD LIB32 /nologo /out:"Release\stlplus3.lib"

!ELSEIF  "$(CFG)" == "stlplus3 - Win32 Debug"

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
# ADD LIB32 /nologo /out:"Debug\stlplus3.lib"

!ENDIF 

# Begin Target

# Name "stlplus3 - Win32 Release"
# Name "stlplus3 - Win32 Debug"
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx"
# Begin Source File

SOURCE=..\..\source\build.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\cli_parser.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\containers.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\containers_fixes.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\copy_functors.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\debug.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\dprintf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\dynaload.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\exceptions.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\file_system.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\format_types.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\inf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\ini_manager.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\ip_sockets.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\library_manager.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\message_handler.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistence.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistence_fixes.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_basic.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_bitset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_bool.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_callback.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_complex.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_contexts.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_cstring.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_deque.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_enum.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_exceptions.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_float.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_inf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_int.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_interface.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_list.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_map.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_multimap.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_multiset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_pair.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_pointer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_pointers.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_set.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_shortcuts.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_stl.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_stlplus.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_string.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_triple.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_vector.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_xref.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\portability.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\portability_exceptions.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\portability_fixes.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_basic.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_bitset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_bool.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_cstring.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_float.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_inf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_int.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_list.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_map.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_pair.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_pointer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_sequence.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_set.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_stl.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_stlplus.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_string.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_triple.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_vector.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\safe_iterator.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\stlplus3.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_basic.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_bitset.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_bool.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_cstring.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_digraph.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_float.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_foursome.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_hash.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_inf.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_int.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_list.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_map.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_matrix.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_ntree.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_pair.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_pointer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_sequence.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_set.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_simple_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_smart_ptr.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_stl.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_stlplus.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_string.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_triple.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_utilities.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_vector.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\strings.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\strings_fixes.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\subprocesses.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\subsystems.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\subsystems_fixes.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\tcp.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\tcp_sockets.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\time.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\timer.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\triple.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\udp_sockets.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\version.hpp
# End Source File
# Begin Source File

SOURCE=..\..\source\wildcard.hpp
# End Source File
# End Group
# Begin Group "Source Files"

# PROP Default_Filter "c;cpp;cxx"
# Begin Source File

SOURCE=..\..\source\build.cpp
DEP_CPP_BUILD=\
	"..\..\source\build.hpp"\
	"..\..\source\dprintf.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\version.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\cli_parser.cpp
DEP_CPP_CLI_P=\
	"..\..\source\cli_parser.hpp"\
	"..\..\source\containers_fixes.hpp"\
	"..\..\source\copy_functors.hpp"\
	"..\..\source\dprintf.hpp"\
	"..\..\source\exceptions.hpp"\
	"..\..\source\file_system.hpp"\
	"..\..\source\ini_manager.hpp"\
	"..\..\source\message_handler.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\smart_ptr.hpp"\
	"..\..\source\smart_ptr.tpp"\
	"..\..\source\subsystems_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\debug.cpp
DEP_CPP_DEBUG=\
	"..\..\source\debug.hpp"\
	"..\..\source\dprintf.hpp"\
	"..\..\source\portability_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\dprintf.cpp
DEP_CPP_DPRIN=\
	"..\..\source\dprintf.hpp"\
	"..\..\source\portability_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\dynaload.cpp
DEP_CPP_DYNAL=\
	"..\..\source\dynaload.hpp"\
	"..\..\source\portability_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\file_system.cpp
DEP_CPP_FILE_=\
	"..\..\source\file_system.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\wildcard.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\inf.cpp
DEP_CPP_INF_C=\
	"..\..\source\inf.hpp"\
	"..\..\source\portability_exceptions.hpp"\
	"..\..\source\portability_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\ini_manager.cpp
DEP_CPP_INI_M=\
	"..\..\source\file_system.hpp"\
	"..\..\source\ini_manager.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\subsystems_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\ip_sockets.cpp
DEP_CPP_IP_SO=\
	"..\..\source\dprintf.hpp"\
	"..\..\source\ip_sockets.hpp"\
	"..\..\source\portability_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\library_manager.cpp
DEP_CPP_LIBRA=\
	"..\..\source\containers_fixes.hpp"\
	"..\..\source\copy_functors.hpp"\
	"..\..\source\exceptions.hpp"\
	"..\..\source\file_system.hpp"\
	"..\..\source\ini_manager.hpp"\
	"..\..\source\library_manager.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\smart_ptr.hpp"\
	"..\..\source\smart_ptr.tpp"\
	"..\..\source\subsystems_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\message_handler.cpp
DEP_CPP_MESSA=\
	"..\..\source\containers_fixes.hpp"\
	"..\..\source\copy_functors.hpp"\
	"..\..\source\dprintf.hpp"\
	"..\..\source\exceptions.hpp"\
	"..\..\source\message_handler.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\smart_ptr.hpp"\
	"..\..\source\smart_ptr.tpp"\
	"..\..\source\subsystems_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_bool.cpp
DEP_CPP_PERSI=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_bool.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_contexts.cpp
DEP_CPP_PERSIS=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_cstring.cpp
DEP_CPP_PERSIST=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_cstring.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	"..\..\source\persistent_int.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_exceptions.cpp
DEP_CPP_PERSISTE=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_float.cpp
DEP_CPP_PERSISTEN=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	"..\..\source\persistent_float.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_inf.cpp
DEP_CPP_PERSISTENT=\
	"..\..\source\inf.hpp"\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	"..\..\source\persistent_inf.hpp"\
	"..\..\source\persistent_int.hpp"\
	"..\..\source\persistent_string.hpp"\
	"..\..\source\persistent_string.tpp"\
	"..\..\source\portability_exceptions.hpp"\
	"..\..\source\portability_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_int.cpp
DEP_CPP_PERSISTENT_=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	"..\..\source\persistent_int.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_string.cpp
DEP_CPP_PERSISTENT_S=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	"..\..\source\persistent_int.hpp"\
	"..\..\source\persistent_string.hpp"\
	"..\..\source\persistent_string.tpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_vector.cpp
DEP_CPP_PERSISTENT_V=\
	"..\..\source\persistence_fixes.hpp"\
	"..\..\source\persistent.hpp"\
	"..\..\source\persistent_contexts.hpp"\
	"..\..\source\persistent_exceptions.hpp"\
	"..\..\source\persistent_int.hpp"\
	"..\..\source\persistent_vector.hpp"\
	"..\..\source\persistent_vector.tpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\portability_fixes.cpp
DEP_CPP_PORTA=\
	"..\..\source\portability_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\print_bool.cpp
DEP_CPP_PRINT_=\
	"..\..\source\format_types.hpp"\
	"..\..\source\print_bool.hpp"\
	"..\..\source\print_int.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\print_cstring.cpp
DEP_CPP_PRINT_C=\
	"..\..\source\print_cstring.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\print_float.cpp
DEP_CPP_PRINT_F=\
	"..\..\source\format_types.hpp"\
	"..\..\source\print_float.hpp"\
	"..\..\source\string_float.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\print_inf.cpp
DEP_CPP_PRINT_I=\
	"..\..\source\format_types.hpp"\
	"..\..\source\inf.hpp"\
	"..\..\source\portability_exceptions.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\print_inf.hpp"\
	"..\..\source\string_inf.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\print_int.cpp
DEP_CPP_PRINT_IN=\
	"..\..\source\format_types.hpp"\
	"..\..\source\print_int.hpp"\
	"..\..\source\string_int.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\print_string.cpp
DEP_CPP_PRINT_S=\
	"..\..\source\print_string.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\print_vector.cpp
DEP_CPP_PRINT_V=\
	"..\..\source\print_pair.hpp"\
	"..\..\source\print_pair.tpp"\
	"..\..\source\print_sequence.hpp"\
	"..\..\source\print_sequence.tpp"\
	"..\..\source\print_vector.hpp"\
	"..\..\source\print_vector.tpp"\
	"..\..\source\string_pair.hpp"\
	"..\..\source\string_pair.tpp"\
	"..\..\source\string_sequence.hpp"\
	"..\..\source\string_sequence.tpp"\
	"..\..\source\string_vector.hpp"\
	"..\..\source\string_vector.tpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_bool.cpp
DEP_CPP_STRING=\
	"..\..\source\format_types.hpp"\
	"..\..\source\string_bool.hpp"\
	"..\..\source\string_int.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_cstring.cpp
DEP_CPP_STRING_=\
	"..\..\source\string_cstring.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_float.cpp
DEP_CPP_STRING_F=\
	"..\..\source\format_types.hpp"\
	"..\..\source\string_float.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_inf.cpp
DEP_CPP_STRING_I=\
	"..\..\source\format_types.hpp"\
	"..\..\source\inf.hpp"\
	"..\..\source\portability_exceptions.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\string_basic.hpp"\
	"..\..\source\string_bool.hpp"\
	"..\..\source\string_cstring.hpp"\
	"..\..\source\string_float.hpp"\
	"..\..\source\string_inf.hpp"\
	"..\..\source\string_int.hpp"\
	"..\..\source\string_pointer.hpp"\
	"..\..\source\string_pointer.tpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_int.cpp
DEP_CPP_STRING_IN=\
	"..\..\source\format_types.hpp"\
	"..\..\source\string_int.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_string.cpp
DEP_CPP_STRING_S=\
	"..\..\source\string_string.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_utilities.cpp
DEP_CPP_STRING_U=\
	"..\..\source\format_types.hpp"\
	"..\..\source\string_basic.hpp"\
	"..\..\source\string_bool.hpp"\
	"..\..\source\string_cstring.hpp"\
	"..\..\source\string_float.hpp"\
	"..\..\source\string_int.hpp"\
	"..\..\source\string_pointer.hpp"\
	"..\..\source\string_pointer.tpp"\
	"..\..\source\string_utilities.hpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\string_vector.cpp
DEP_CPP_STRING_V=\
	"..\..\source\string_pair.hpp"\
	"..\..\source\string_pair.tpp"\
	"..\..\source\string_sequence.hpp"\
	"..\..\source\string_sequence.tpp"\
	"..\..\source\string_vector.hpp"\
	"..\..\source\string_vector.tpp"\
	"..\..\source\strings_fixes.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\subprocesses.cpp
DEP_CPP_SUBPR=\
	"..\..\source\dprintf.hpp"\
	"..\..\source\file_system.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\subprocesses.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\tcp_sockets.cpp
DEP_CPP_TCP_S=\
	"..\..\source\ip_sockets.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\tcp_sockets.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\time.cpp
DEP_CPP_TIME_=\
	"..\..\source\dprintf.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\time.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\timer.cpp
DEP_CPP_TIMER=\
	"..\..\source\dprintf.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\subsystems_fixes.hpp"\
	"..\..\source\time.hpp"\
	"..\..\source\timer.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\udp_sockets.cpp
DEP_CPP_UDP_S=\
	"..\..\source\ip_sockets.hpp"\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\udp_sockets.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\version.cpp
DEP_CPP_VERSI=\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\version.hpp"\
	
# End Source File
# Begin Source File

SOURCE=..\..\source\wildcard.cpp
DEP_CPP_WILDC=\
	"..\..\source\portability_fixes.hpp"\
	"..\..\source\wildcard.hpp"\
	
# End Source File
# End Group
# Begin Group "Template Implementations"

# PROP Default_Filter "tpp;txx"
# Begin Source File

SOURCE=..\..\source\digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_bitset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_callback.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_complex.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_deque.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_enum.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_interface.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_list.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_map.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_multimap.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_multiset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_pair.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_pointer.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_set.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_shortcuts.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_string.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_triple.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_vector.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\persistent_xref.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_bitset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_list.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_map.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_pair.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_pointer.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_sequence.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_set.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_triple.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\print_vector.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\safe_iterator.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_bitset.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_digraph.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_foursome.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_hash.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_list.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_map.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_matrix.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_ntree.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_pair.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_pointer.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_sequence.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_set.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_simple_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_smart_ptr.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_triple.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\string_vector.tpp
# End Source File
# Begin Source File

SOURCE=..\..\source\triple.tpp
# End Source File
# End Group
# End Target
# End Project
