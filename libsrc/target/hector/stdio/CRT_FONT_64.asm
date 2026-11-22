
    SECTION rodata_clib

    PUBLIC  CRT_FONT_64

IF FORhector1
    EXTERN  _font_4x8_default
    defc    CRT_FONT_64 = _font_4x8_default
ELSE
    defc    CRT_FONT_64=0
ENDIF
