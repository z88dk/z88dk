
; uchar zx_bitmask2px(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC zx_bitmask2px

EXTERN asm_zx_bitmask2px

defc zx_bitmask2px = asm_zx_bitmask2px

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_bitmask2px
defc _zx_bitmask2px = zx_bitmask2px
ENDIF

