    SECTION code_driver

IFNDEF FORsam
    PUBLIC  generic_console_scrollup
    EXTERN  __zx_scrollup

    defc    generic_console_scrollup=__zx_scrollup
ENDIF
