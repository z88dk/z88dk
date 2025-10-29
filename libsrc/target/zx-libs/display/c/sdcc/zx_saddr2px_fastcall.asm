
; uint zx_saddr2px_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2px_fastcall

EXTERN asm_zx_saddr2px

defc _zx_saddr2px_fastcall = asm_zx_saddr2px
