
; void *zx_aaddrcdown(void *attraddr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_aaddrcdown

EXTERN asm_zx_aaddrcdown

_zx_aaddrcdown:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_zx_aaddrcdown
