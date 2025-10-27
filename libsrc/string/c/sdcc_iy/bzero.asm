
; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

PUBLIC _bzero

EXTERN asm_bzero

_bzero:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_bzero
