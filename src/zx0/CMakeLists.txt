add_executable(z88dk-zx0
    "compress.c"
    "optimize.c"
    "zx0.c"
    "memory.c"
)
install(TARGETS z88dk-zx0 DESTINATION bin)

add_executable(z88dk-dzx0
    "dzx0.c"
)
install(TARGETS z88dk-dzx0 DESTINATION bin)
