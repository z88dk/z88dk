
; void _lldiv_(lldiv_t *ld, int64_t numer, int64_t denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __lldiv_

EXTERN asm__lldiv

__lldiv_:
   
   ld ix,4
   add ix,sp
   
   jp asm__lldiv
