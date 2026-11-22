
; void *zx_saddrpdown_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpdown_fastcall

EXTERN asm_zx_saddrpdown

defc _zx_saddrpdown_fastcall = asm_zx_saddrpdown
