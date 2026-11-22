
; void *zx_aaddrcup_fastcall(void *aaddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcup_fastcall

EXTERN asm_zx_aaddrcup

defc _zx_aaddrcup_fastcall = asm_zx_aaddrcup
