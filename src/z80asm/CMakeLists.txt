# $(filter-out src/c/test.c, $(wildcard src/c/*.c ../common/*.c ../../ext/regex/reg*.c))
file(GLOB C_SRCS
    "src/c/*.c"
)
list(REMOVE_ITEM C_SRCS
    "src/c/test.c"
)
# $(wildcard src/cpp/*.cpp)
file(GLOB CXX_SRCS
    "src/cpp/*.cpp"
)

add_executable(z88dk-z80asm
    ${C_SRCS}
    ${CXX_SRCS}
)
target_include_directories(z88dk-z80asm PRIVATE
    "./"
    "src/"
    "src/c/"
    "t/"
)
target_compile_features(z88dk-z80asm PRIVATE cxx_std_17)
target_link_libraries(z88dk-z80asm PRIVATE common unity)
install(TARGETS z88dk-z80asm DESTINATION bin)
