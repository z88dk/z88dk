
; uchar zx_aaddr2cy(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddr2cy

EXTERN asm_zx_aaddr2cy

defc zx_aaddr2cy = asm_zx_aaddr2cy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_aaddr2cy
defc _zx_aaddr2cy = zx_aaddr2cy
ENDIF

