
    SECTION code_driver

    PUBLIC  generic_console_vpeek
    EXTERN  __sam_vpeek

    defc    generic_console_vpeek = __sam_vpeek
