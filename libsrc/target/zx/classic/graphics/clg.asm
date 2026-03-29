    SECTION code_clib
    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  generic_console_cls
    EXTERN  generic_console_cls_with_mode
    EXTERN  __zx_gfxmode

IF FORzxn
clg:
_clg:
    ld      a, (__zx_gfxmode)
    jp      generic_console_cls_with_mode
ELSE
    defc clg = generic_console_cls
    defc _clg = clg
ENDIF




