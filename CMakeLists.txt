cmake_minimum_required(VERSION 3.22)
project(Z88DK)
option(BUILD_SDCC "Build SDCC" ON)
option(BUILD_SDCC_HTTP "Download SDCC using HTTP instead of SVN" OFF)
set(SDCC_PATH "src/sdcc-build" CACHE STRING "Path to SDCC")
set(SDCC_VERSION "14648" CACHE STRING "SDCC version")

if(EXISTS "${CMAKE_SOURCE_DIR}/.git" AND EXISTS "/usr/bin/git")
    execute_process(
        COMMAND git rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_REV
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git rev-list --count HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COUNT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
else()
    set(GIT_REV "unknown")
    set(GIT_COUNT "unknown")
endif()

execute_process(
    COMMAND date +%Y%m%d
    OUTPUT_VARIABLE VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

configure_file("src/config.h.in" "${PROJECT_SOURCE_DIR}/src/config.h")

if(BUILD_SDCC)
    if(BUILD_SDCC_HTTP)
        add_custom_command(
            COMMENT "Downloading SDCC"
            OUTPUT zsdcc_r${SDCC_VERSION}_src.tar.gz
            COMMAND wget -nc "http://nightly.z88dk.org/zsdcc/zsdcc_r${SDCC_VERSION}_src.tar.gz"
        )

        add_custom_command(
            COMMENT "Extracting SDCC"
            OUTPUT ${PROJECT_SOURCE_DIR}/${SDCC_PATH}
            DEPENDS zsdcc_r${SDCC_VERSION}_src.tar.gz
            COMMAND tar xzf "zsdcc_r${SDCC_VERSION}_src.tar.gz" -C ${PROJECT_SOURCE_DIR}
        )
    else()
        add_custom_command(
            COMMENT "Downloading SDCC"
            OUTPUT ${PROJECT_SOURCE_DIR}/${SDCC_PATH}
            COMMAND svn checkout -r ${SDCC_VERSION} https://svn.code.sf.net/p/sdcc/code/trunk/sdcc ${PROJECT_SOURCE_DIR}/${SDCC_PATH}
        )
    endif()

    add_custom_target(z88dk-zsdcc
        ALL
        DEPENDS ${PROJECT_SOURCE_DIR}/${SDCC_PATH}
        COMMAND cd ${PROJECT_SOURCE_DIR}/${SDCC_PATH} && ./configure --disable-ds390-port --disable-ds400-port --disable-hc08-port --disable-s08-port --disable-mcs51-port --disable-pic-port --disable-pic14-port --disable-pic16-port --disable-tlcs90-port --disable-xa51-port --disable-stm8-port --disable-pdk13-port --disable-pdk14-port --disable-pdk15-port --disable-pdk16-port --disable-mos6502-port --disable-mos65c02-port --disable-r2k-port --disable-non-free --disable-device-lib --disable-ucsim --disable-packihx --disable-sdcpp --disable-sdcdb --disable-sdbinutil
        COMMAND cd ${PROJECT_SOURCE_DIR}/${SDCC_PATH} && make -j4
    )

    install(PROGRAMS ${PROJECT_SOURCE_DIR}/${SDCC_PATH}/src/sdcc DESTINATION bin RENAME z88dk-zsdcc)
endif()

add_subdirectory(src/common)
add_subdirectory(src/copt)
add_subdirectory(src/sccz80)
add_subdirectory(src/ucpp)
add_subdirectory(src/z80asm)
add_subdirectory(src/zcc)
add_subdirectory(src/zpragma)
add_subdirectory(src/zx0)

# `libsrc` stuff
include(ProcessorCount)
ProcessorCount(NPROC)

set(LIBSRC_OVERRIDES
    ZCCCFG=${PROJECT_SOURCE_DIR}/lib/config
    PATH=/bin:/usr/bin:${CMAKE_BINARY_DIR}/src/zcc:${CMAKE_BINARY_DIR}/src/ucpp:${CMAKE_BINARY_DIR}/src/zpragma:${CMAKE_BINARY_DIR}/src/sccz80:${CMAKE_BINARY_DIR}/src/copt:${CMAKE_BINARY_DIR}/src/z80asm:${CMAKE_BINARY_DIR}/src/zx0
)

add_custom_target(libsrc
    ALL
    DEPENDS zcc z88dk-ucpp z88dk-zpragma z88dk-sccz80 z88dk-copt z88dk-z80asm z88dk-zx0
    BYPRODUCTS ${CMAKE_BINARY_DIR}/libsrc
    COMMAND make -C ${PROJECT_SOURCE_DIR}/libsrc ${LIBSRC_OVERRIDES} -j${NPROC} && make -C ${PROJECT_SOURCE_DIR}/libsrc install
    COMMAND make -C ${PROJECT_SOURCE_DIR}/libsrc/_DEVELOPMENT ${LIBSRC_OVERRIDES} -j${NPROC}
    COMMAND make -C ${PROJECT_SOURCE_DIR}/include/_DEVELOPMENT ${LIBSRC_OVERRIDES} -j${NPROC}

    # Cleanup
    COMMAND find ${PROJECT_SOURCE_DIR}/libsrc -name "*.o" -type f -delete # Intermediate files, not needed
    COMMAND find ${PROJECT_SOURCE_DIR}/libsrc -name "*.lib" -type f -delete # They'd already be moved to `lib/clibs`
)

# Install standard library
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include DESTINATION share/z88dk)
install(DIRECTORY ${PROJECT_SOURCE_DIR}/lib DESTINATION share/z88dk)
install(DIRECTORY ${PROJECT_SOURCE_DIR}/libsrc DESTINATION share/z88dk/)
