
; void *zx_saddrcleft_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcleft_fastcall

EXTERN asm_zx_saddrcleft

defc _zx_saddrcleft_fastcall = asm_zx_saddrcleft
