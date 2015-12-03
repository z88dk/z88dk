
; void *balloc_alloc(unsigned int queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_alloc

EXTERN asm_balloc_alloc

_balloc_alloc:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_balloc_alloc
