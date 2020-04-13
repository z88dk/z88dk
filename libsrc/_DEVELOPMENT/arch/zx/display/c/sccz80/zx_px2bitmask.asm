
; uchar zx_px2bitmask(uchar x)

SECTION code_clib
SECTION code_arch

PUBLIC zx_px2bitmask

EXTERN asm_zx_px2bitmask

defc zx_px2bitmask = asm_zx_px2bitmask

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_px2bitmask
defc _zx_px2bitmask = zx_px2bitmask
ENDIF

