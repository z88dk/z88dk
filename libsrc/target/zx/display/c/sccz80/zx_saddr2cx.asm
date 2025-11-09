
; uchar zx_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2cx

EXTERN asm_zx_saddr2cx

defc zx_saddr2cx = asm_zx_saddr2cx

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddr2cx
defc _zx_saddr2cx = zx_saddr2cx
ENDIF

