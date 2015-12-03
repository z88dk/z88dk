
; uint zx_saddr2cx(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2cx

EXTERN asm_zx_saddr2cx

defc zx_saddr2cx = asm_zx_saddr2cx
