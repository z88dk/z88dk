
; void *zx_saddrpup_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpup_fastcall

EXTERN asm_zx_saddrpup

defc _zx_saddrpup_fastcall = asm_zx_saddrpup
