
; uint zx_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2py

EXTERN asm_zx_saddr2py

defc zx_saddr2py = asm_zx_saddr2py
