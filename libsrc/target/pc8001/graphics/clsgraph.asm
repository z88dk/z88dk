
    SECTION code_clib
    PUBLIC  cleargraphics
    PUBLIC  _cleargraphics
    EXTERN  generic_console_cls
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_hires_cls

; In a hires mode this clears the graphics screen and leaves the text.
; The semigraphics share the text screen, so that is cleared instead.
cleargraphics:
_cleargraphics:
    ld      a, (__pc8001_gfxmode)
    and     a
    jp      nz, __pc8001_hires_cls
    jp      generic_console_cls
