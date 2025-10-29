; void *balloc_reset(unsigned char queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_reset

EXTERN asm_balloc_reset

_balloc_reset:

   pop af
   pop hl

   push hl
   push af

   jp asm_balloc_reset
