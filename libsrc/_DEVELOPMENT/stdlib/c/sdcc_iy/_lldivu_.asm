
; void _lldivu_(lldivu_t *ld, uint64_t numer, uint64_t denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __lldivu_

EXTERN asm__lldivu

__lldivu_:
   
   ld ix,4
   add ix,sp
   
   jp asm__lldivu
