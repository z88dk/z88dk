
; void *zx_saddrcright_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcright_fastcall

EXTERN asm_zx_saddrcright

defc _zx_saddrcright_fastcall = asm_zx_saddrcright
