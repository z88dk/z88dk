
; void *zx_aaddrcleft(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_aaddrcleft

EXTERN asm_zx_aaddrcleft

defc zx_aaddrcleft = asm_zx_aaddrcleft

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_aaddrcleft
defc _zx_aaddrcleft = zx_aaddrcleft
ENDIF

