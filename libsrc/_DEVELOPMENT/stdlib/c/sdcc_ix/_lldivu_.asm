
; void _lldivu_(lldivu_t *ld, uint64_t numer, uint64_t denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __lldivu_

EXTERN asm__lldivu

__lldivu_:

   push ix
   
   ld ix,6
   add ix,sp
   
   call asm__lldivu
   
   pop ix
   ret
