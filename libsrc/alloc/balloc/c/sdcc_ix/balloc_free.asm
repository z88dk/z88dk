
; void balloc_free(void *m)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_free

EXTERN asm_balloc_free

_balloc_free:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_balloc_free
