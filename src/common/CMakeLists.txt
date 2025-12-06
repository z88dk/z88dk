add_library(common STATIC
    "die.c"
    "dirname.c"
    "fileutil.c"
    "objfile.c"
    "option.c"
    "optparse.c"
    "stack_trace.c"
    "strpool.c"
    "strtable.c"
    "strutil.c"
    "xassert.c"
    "xmalloc.c"
    "z80asm_defs.c"
)
target_include_directories(common PUBLIC . "../../ext/uthash/src" "../../ext/optparse/" "../../ext/regex/")
