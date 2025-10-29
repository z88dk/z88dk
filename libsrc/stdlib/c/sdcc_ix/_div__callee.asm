
; void _div__callee(div_t *d, int numer, int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __div__callee

EXTERN asm__div

__div__callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm__div
