
; void *zx_saddrpright_callee(void *saddr, uint bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_saddrpright_callee

EXTERN asm_zx_saddrpright

_zx_saddrpright_callee:

   pop af
   pop hl
   dec sp
   pop de
   push af

   ld e,d
   jp asm_zx_saddrpright
