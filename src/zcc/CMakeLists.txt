add_executable(zcc
    "zcc.c"

    "../copt/regex/regcomp.c"
    "../copt/regex/regerror.c"
    "../copt/regex/regexec.c"
    "../copt/regex/regfree.c"

    "../common/dirname.c"
    "../common/option.c"
)

target_include_directories(zcc PRIVATE
    "."
    "../copt"
    "../common"
    "../../ext/uthash/src"
)

target_compile_definitions(zcc PRIVATE LOCAL_REGEXP)

install(TARGETS zcc DESTINATION bin)
