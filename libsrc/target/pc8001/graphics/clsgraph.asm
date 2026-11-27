
    SECTION code_clib
    PUBLIC  cleargraphics
    PUBLIC  _cleargraphics
    EXTERN  generic_console_cls

cleargraphics:
_cleargraphics:
    jp      generic_console_cls
