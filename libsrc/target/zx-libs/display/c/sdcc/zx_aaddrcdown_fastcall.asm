
; void *zx_aaddrcdown_fastcall(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcdown_fastcall

EXTERN asm_zx_aaddrcdown

defc _zx_aaddrcdown_fastcall = asm_zx_aaddrcdown
