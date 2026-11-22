
; void srand(unsigned int seed)

SECTION code_clib
SECTION code_stdlib

PUBLIC _srand

EXTERN asm_srand

_srand:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_srand
