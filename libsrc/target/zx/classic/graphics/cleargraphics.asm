

    SECTION code_clib
    PUBLIC  cleargraphics
    PUBLIC  _cleargraphics
    EXTERN  generic_console_cls
    EXTERN  generic_console_cls_with_mode
    EXTERN  __zx_gfxmode

IF FORzxn
cleargraphics:
_cleargraphics:
    ld      a, (__zx_gfxmode)
    jp      generic_console_cls_with_mode
ELSE
    defc    cleargraphics=generic_console_cls
    defc    _cleargraphics=generic_console_cls
ENDIF
