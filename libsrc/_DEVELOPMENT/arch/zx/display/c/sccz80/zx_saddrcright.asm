
; void *zx_saddrcright(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrcright

EXTERN asm_zx_saddrcright

defc zx_saddrcright = asm_zx_saddrcright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddrcright
defc _zx_saddrcright = zx_saddrcright
ENDIF

