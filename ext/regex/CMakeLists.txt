
# CMakeLists.txt, generated gencmake.pl, on 2017/08/07 15:23:54
cmake_minimum_required( VERSION 2.8.8 )

# CMakeScripts or use the ones that come by default with CMake.
# set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMakeModules ${CMAKE_MODULE_PATH})

project( regex )

# The version number.
set( regex_MAJOR 3 )
set( regex_MINOR 0 )
set( regex_POINT 0 )


# Allow developer to select is Dynamic or static library built
set( LIB_TYPE STATIC )  # set default static
option( BUILD_SHARED_LIB "Set ON to build shared Library (DLL)" OFF )


if(CMAKE_COMPILER_IS_GNUCXX)
    set( WARNING_FLAGS -Wall )
endif(CMAKE_COMPILER_IS_GNUCXX)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang") 
   set( WARNING_FLAGS "-Wall -Wno-overloaded-virtual" )
endif() 

if(WIN32 AND MSVC)
    # turn off various warnings
    set(WARNING_FLAGS "${WARNING_FLAGS} /wd4996")
    # C4267: '=': conversion from 'size_t' to 'sopno'
    # C4244: '=': conversion from '__int64' to 'regoff_t'
    # foreach(warning 4244 4251 4267 4275 4290 4786 4305)
    foreach(warning 4244 4267 )
         set(WARNING_FLAGS "${WARNING_FLAGS} /wd${warning}")
    endforeach()
    set( MSVC_FLAGS "-DNOMINMAX -D_USE_MATH_DEFINES -D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS -D__CRT_NONSTDC_NO_WARNINGS" )
    # if (${MSVC_VERSION} EQUAL 1600)
    #    set( MSVC_LD_FLAGS "/FORCE:MULTIPLE" )
    # endif (${MSVC_VERSION} EQUAL 1600)
    #set( NOMINMAX 1 )
    # to distinguish between debug and release libs
    set( CMAKE_DEBUG_POSTFIX "d" )
else()
    # items for unix
endif()

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${WARNING_FLAGS} ${MSVC_FLAGS} -D_REENTRANT" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNING_FLAGS} ${MSVC_FLAGS} -D_REENTRANT" )
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MSVC_LD_FLAGS}" )

# configuration file, if needed
# configure_file( ${CMAKE_SOURCE_DIR}/config.h.cmake ${CMAKE_BINARY_DIR}/config.h )
# add_definitions( -DHAVE_CONFIG_H )
# include_directories( ${CMAKE_BINARY_DIR} )

if(BUILD_SHARED_LIB)
   set(LIB_TYPE SHARED)
   message(STATUS "*** Building DLL library ${LIB_TYPE}")
else()
   message(STATUS "*** Option BUILD_SHARED_LIB is OFF ${LIB_TYPE}")
endif()
# Total libs 1, exes 1
#################################################
##### LIBRARIES 1 #####
#################################################
set(name regex)
set(dir .)
#   ${dir}/engine.c - is included in regexec.c, twice
set(${name}_SRCS
    ${dir}/regcomp.c
    ${dir}/regerror.c
    ${dir}/regexec.c
    ${dir}/regfree.c
    )
set(${name}_HDRS
    ${dir}/regex.h
    )
add_library( ${name} ${${name}_SRCS} ${${name}_HDRS} )
list(APPEND add_LIBS ${name})
# deal with install, if any...
install( TARGETS ${name}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib )
install(FILES ${${name}_HDRS} DESTINATION include)

#################################################
##### EXECUTABLES ??? #####
#################################################

# regex-fork EXECUTABLE from [X:\regex-fork],
# have 8 C/C++ sources, 5 headers
set(name re-test)
set(dir .)
set(${name}_SRCS
    ${dir}/debug.c
    ${dir}/main.c
    ${dir}/split.c
    )
set(${name}_HDRS
    ${dir}/cclass.h
    ${dir}/cname.h
    ${dir}/regex2.h
    ${dir}/utils.h
    )
if (MSVC)
    list(APPEND ${name}_SRCS ${dir}/utils/getopt.c)
    list(APPEND ${name}_HDRS ${dir}/utils/getopt.h)
endif ()
add_executable( ${name} ${${name}_SRCS} ${${name}_HDRS} )
if (add_LIBS)
    target_link_libraries( ${name} ${add_LIBS} )
endif ()
if (MSVC)
    set_target_properties( ${name} PROPERTIES DEBUG_POSTFIX d )
endif ()
# deal with install, if any...
#install( TARGETS ${name} DESTINATION bin )

# eof
