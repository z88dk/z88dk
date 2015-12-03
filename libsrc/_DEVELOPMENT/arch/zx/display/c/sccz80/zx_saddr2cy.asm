
; uint zx_saddr2cy(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2cy

EXTERN asm_zx_saddr2cy

defc zx_saddr2cy = asm_zx_saddr2cy
