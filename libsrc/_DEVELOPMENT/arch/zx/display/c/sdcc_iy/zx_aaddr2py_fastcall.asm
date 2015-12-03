
; uint zx_aaddr2py_fastcall(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2py_fastcall

EXTERN asm_zx_aaddr2py

defc _zx_aaddr2py_fastcall = asm_zx_aaddr2py
