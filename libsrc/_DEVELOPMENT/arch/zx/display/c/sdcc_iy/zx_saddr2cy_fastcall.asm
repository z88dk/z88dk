
; uint zx_saddr2cy_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2cy_fastcall

EXTERN asm_zx_saddr2cy

defc _zx_saddr2cy_fastcall = asm_zx_saddr2cy
