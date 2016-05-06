
; void _lldivu_(lldivu_t *ld, uint64_t numer, uint64_t denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __lldivu__callee

EXTERN asm__lldivu

__lldivu__callee:

   push ix
   
   ld ix,6
   add ix,sp
   
   call asm__lldivu
   
   pop ix
   pop de
   
   ld hl,18
   add hl,sp
   ld sp,hl
   
   ex de,hl
   jp (hl)
