
; uint zx_saddr2cx_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2cx_fastcall

EXTERN asm_zx_saddr2cx

defc _zx_saddr2cx_fastcall = asm_zx_saddr2cx
