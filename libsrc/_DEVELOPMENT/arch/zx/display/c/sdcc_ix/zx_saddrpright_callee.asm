
; void *zx_saddrpright_callee(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpright_callee

EXTERN asm_zx_saddrpright

_zx_saddrpright_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_zx_saddrpright
