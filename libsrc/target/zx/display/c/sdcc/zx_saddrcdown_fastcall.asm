
; void *zx_saddrcdown_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcdown_fastcall

EXTERN asm_zx_saddrcdown

defc _zx_saddrcdown_fastcall = asm_zx_saddrcdown
