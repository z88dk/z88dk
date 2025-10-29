
; void *zx_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpup

EXTERN asm_zx_saddrpup

defc zx_saddrpup = asm_zx_saddrpup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddrpup
defc _zx_saddrpup = zx_saddrpup
ENDIF

