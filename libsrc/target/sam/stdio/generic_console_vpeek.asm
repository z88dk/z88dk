
    SECTION code_clib

    PUBLIC  generic_console_vpeek
    EXTERN  __sam_vpeek

    defc    generic_console_vpeek = __sam_vpeek
