
; uint zx_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2py

EXTERN asm_zx_saddr2py

_zx_saddr2py:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddr2py
