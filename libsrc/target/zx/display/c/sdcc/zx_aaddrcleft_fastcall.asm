
; void *zx_aaddrcleft_fastcall(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcleft_fastcall

EXTERN asm_zx_aaddrcleft

defc _zx_aaddrcleft_fastcall = asm_zx_aaddrcleft
