
; uchar zx_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2py

EXTERN asm_zx_saddr2py

defc zx_saddr2py = asm_zx_saddr2py

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_saddr2py
defc _zx_saddr2py = zx_saddr2py
ENDIF

