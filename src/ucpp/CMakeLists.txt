add_executable(z88dk-ucpp
    "mem.c"
    "nhash.c"
    "cpp.c"
    "lexer.c"
    "assert.c"
    "macro.c"
    "eval.c"
)

target_compile_definitions(z88dk-ucpp PRIVATE STAND_ALONE UCPP_CONFIG)

install(TARGETS z88dk-ucpp DESTINATION bin)
