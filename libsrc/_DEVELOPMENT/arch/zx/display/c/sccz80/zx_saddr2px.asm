
; uint zx_saddr2px(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddr2px

EXTERN asm_zx_saddr2px

defc zx_saddr2px = asm_zx_saddr2px
