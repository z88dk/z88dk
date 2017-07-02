
; void *zx_saddrcup_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrcup_fastcall

EXTERN asm_zx_saddrcup

defc _zx_saddrcup_fastcall = asm_zx_saddrcup
