
; BSD
; void bzero(void *mem, int bytes)

SECTION code_clib
SECTION code_string

PUBLIC bzero

EXTERN asm_bzero

bzero:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_bzero
