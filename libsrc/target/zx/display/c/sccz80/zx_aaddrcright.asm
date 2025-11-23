
; void *zx_aaddrcright(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddrcright

EXTERN asm_zx_aaddrcright

defc zx_aaddrcright = asm_zx_aaddrcright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_aaddrcright
defc _zx_aaddrcright = zx_aaddrcright
ENDIF

