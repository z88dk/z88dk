
; void *zx_cy2saddr(uchar row)

SECTION code_clib
SECTION code_arch

PUBLIC zx_cy2saddr

EXTERN asm_zx_cy2saddr

defc zx_cy2saddr = asm_zx_cy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_cy2saddr
defc _zx_cy2saddr = zx_cy2saddr
ENDIF

