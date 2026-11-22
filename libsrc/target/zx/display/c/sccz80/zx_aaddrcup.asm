
; void *zx_aaddrcup(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddrcup

EXTERN asm_zx_aaddrcup

defc zx_aaddrcup = asm_zx_aaddrcup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_aaddrcup
defc _zx_aaddrcup = zx_aaddrcup
ENDIF

