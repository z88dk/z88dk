
; void *zx_aaddrcright_fastcall(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcright_fastcall

EXTERN asm_zx_aaddrcright

defc _zx_aaddrcright_fastcall = asm_zx_aaddrcright
