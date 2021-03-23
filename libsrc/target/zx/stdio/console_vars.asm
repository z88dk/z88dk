
    MODULE  console_vars

    PUBLIC  __zx_screenmode
    PUBLIC  __zx_32col_font
    PUBLIC  __zx_32col_udgs
    PUBLIC  __zx_64col_font
    PUBLIC  __zx_print_routine

    EXTERN  CRT_FONT
    EXTERN  CRT_FONT_64


    SECTION data_clib

__zx_32col_font:
    defw    CRT_FONT
__zx_64col_font:
    defw    CRT_FONT_64
__zx_32col_udgs:
    defw    65368

__zx_print_routine:
    defw    0


; TS2068 screen mode (values in gencon mode)
; 0 = use screen 0
; 1 = use screen 1
; 2 = high colour
; 6 = hires
; bit 6 set = tilemap (ZXN)
__zx_screenmode:
IF FORsam
    defb    3       ;Mode 4 is the default mode
ELSE
    defb    0       ;If set TS2068 hrgmode is active
ENDIF


