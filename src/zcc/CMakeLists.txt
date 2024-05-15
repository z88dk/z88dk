add_executable(zcc
    "zcc.c"

    "../copt/regex/regcomp.c"
    "../copt/regex/regerror.c"
    "../copt/regex/regexec.c"
    "../copt/regex/regfree.c"
)

target_include_directories(zcc PRIVATE
    "."
    "../copt"
)
target_compile_definitions(zcc PRIVATE LOCAL_REGEXP)
target_link_libraries(zcc PRIVATE common)

install(TARGETS zcc DESTINATION bin)
