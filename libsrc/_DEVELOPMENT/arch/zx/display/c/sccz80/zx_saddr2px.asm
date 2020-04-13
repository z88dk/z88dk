
; uchar zx_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2px

EXTERN asm_zx_saddr2px

defc zx_saddr2px = asm_zx_saddr2px

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddr2px
defc _zx_saddr2px = zx_saddr2px
ENDIF

