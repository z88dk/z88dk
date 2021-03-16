
    SECTION code_clib

    PUBLIC  generic_console_vpeek
    EXTERN  __zx_vpeek

    defc    generic_console_vpeek = __zx_vpeek