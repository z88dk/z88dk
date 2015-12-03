
; uint zx_aaddr2py(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2py

EXTERN asm_zx_aaddr2py

_zx_aaddr2py:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddr2py
