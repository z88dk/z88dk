;
; Shared variables between the VT100 and VT52 engines


    MODULE  conio_vars
    SECTION data_clib

    PUBLIC  __x1_attr
    PUBLIC  __x1_mode
    PUBLIC  __x1_pcg_mode
    EXTERN  CLIB_DEFAULT_SCREEN_MODE

.__x1_attr       defb $7, $0	; White on Black

.__x1_mode	defb	CLIB_DEFAULT_SCREEN_MODE

.__x1_pcg_mode defb    0       ;Bit 0 = custom font, bit 1 = custom udgs
