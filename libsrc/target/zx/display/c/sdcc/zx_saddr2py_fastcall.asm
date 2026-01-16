
; uint zx_saddr2py_fastcall(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2py_fastcall

EXTERN asm_zx_saddr2py

defc _zx_saddr2py_fastcall = asm_zx_saddr2py
