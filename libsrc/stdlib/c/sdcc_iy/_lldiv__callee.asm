
; void _lldiv_(lldiv_t *ld, int64_t numer, int64_t denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __lldiv__callee

EXTERN asm__lldiv

__lldiv__callee:
   
   ld ix,4
   add ix,sp
   
   call asm__lldiv
   
   pop de
   
   ld hl,18
   add hl,sp
   ld sp,hl
   
   ex de,hl
   jp (hl)
