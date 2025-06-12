add_executable(z88dk-z80asm
    # ${C_SRCS}
    "src/c/alloc.c"
    "src/c/array.c"
    "src/c/class.c"
    "src/c/codearea.c"
    "src/c/common.c"
    "src/c/cpu_rules_action.c"
    "src/c/dbg.c"
    "src/c/directives.c"
    "src/c/expr1.c"
    "src/c/libfile.c"
    "src/c/list.c"
    "src/c/minunit.c"
    "src/c/modlink.c"
    "src/c/module1.c"
    "src/c/opcodes.c"
    "src/c/parse1.c"
    "src/c/reloc_code.c"
    "src/c/scan1.c"
    "src/c/str.c"
    "src/c/strhash.c"
    "src/c/sym.c"
    "src/c/symtab1.c"
    "src/c/z80asm1.c"
    "src/c/z80pass.c"
    "src/c/zobjfile.c"

    # ${CXX_SRCS}
    "src/args.cpp"
    "src/errors.cpp"
    "src/file_reader.cpp"
    "src/utils.cpp"
    "src/cpp/defines.cpp"
    "src/cpp/float.cpp"
    "src/cpp/lstfile.cpp"
    "src/cpp/main.cpp"
    "src/cpp/preproc.cpp"
    "src/cpp/scan2.cpp"
    "src/cpp/utils2.cpp"
)
target_include_directories(z88dk-z80asm PRIVATE
    "./"
    "src/"
    "src/c/"
    "t/"

    # Idk where this is declared from, so I'll put it here
    "../../ext/Unity/src/"
)
target_compile_features(z88dk-z80asm PRIVATE cxx_std_17)
target_link_libraries(z88dk-z80asm PRIVATE common)
install(TARGETS z88dk-z80asm DESTINATION bin)
