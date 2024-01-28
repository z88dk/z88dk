# $(filter-out src/c/test.c, $(wildcard src/c/*.c ../common/*.c ../../ext/regex/reg*.c))
file(GLOB C_SRCS
    "src/c/*.c"
    "../common/*.c"
    "../../ext/regex/reg*.c"
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
    # Common stuff
    "./"
    "src/"
    "../common/"

    # Local stuff
    "src/c/"
    "t/"
    "../../ext/optparse/"
    "../../ext/regex/"
    "../../ext/uthash/src/"

    # Idk where this is declared from, so I'll put it here
    "../../ext/Unity/src/"
)
target_compile_features(z88dk-z80asm PRIVATE cxx_std_17)
install(TARGETS z88dk-z80asm DESTINATION bin)
