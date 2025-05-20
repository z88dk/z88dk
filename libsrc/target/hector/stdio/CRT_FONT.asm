
    SECTION rodata_clib

    PUBLIC  CRT_FONT

IF FORhectorhr
    EXTERN  _font_8x8_zx_system
    defc    CRT_FONT=_font_8x8_zx_system
ELSE
    defc    CRT_FONT=0
ENDIF
