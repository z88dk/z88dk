add_executable(z88dk-sccz80
    "callfunc.c" # Not in the original Makefile, but won't compile without it
    "cdbfile.c"
    "codegen.c"
    "const.c"
    "data.c"
    "declinit.c"
    "error.c"
    "expr.c"
    "goto.c"
    "io.c"
    "lex.c"
    "main.c"
    "misc.c"
    "plunge.c"
    "preproc.c"
    "primary.c"
    "stmt.c"
    "sym.c"
    "while.c"
    "declparse.c"
)
target_link_libraries(z88dk-sccz80 PRIVATE
    m # This caught me so off guard
    common
)

install(TARGETS z88dk-sccz80 DESTINATION bin)
