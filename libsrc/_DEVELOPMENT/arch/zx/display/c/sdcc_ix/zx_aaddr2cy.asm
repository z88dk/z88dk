
; uint zx_aaddr2cy(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddr2cy

EXTERN asm_zx_aaddr2cy

_zx_aaddr2cy:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddr2cy
