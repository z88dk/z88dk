
; void *zx_saddr2aaddr(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2aaddr

EXTERN asm_zx_saddr2aaddr

defc zx_saddr2aaddr = asm_zx_saddr2aaddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddr2aaddr
defc _zx_saddr2aaddr = zx_saddr2aaddr
ENDIF

