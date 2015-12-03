
; BSD
; void bzero_callee(void *mem, int bytes)

SECTION code_clib
SECTION code_string

PUBLIC _bzero_callee

EXTERN asm_bzero

_bzero:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_bzero
