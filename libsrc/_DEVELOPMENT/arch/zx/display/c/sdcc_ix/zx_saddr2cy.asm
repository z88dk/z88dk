
; uint zx_saddr2cy(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddr2cy

EXTERN asm_zx_saddr2cy

_zx_saddr2cy:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_saddr2cy
