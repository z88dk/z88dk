
; void *zx_saddrcup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrcup

EXTERN asm_zx_saddrcup

defc zx_saddrcup = asm_zx_saddrcup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddrcup
defc _zx_saddrcup = zx_saddrcup
ENDIF

