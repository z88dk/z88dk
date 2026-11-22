SECTION code_clib
SECTION code_l_xcc

PUBLIC __sdiv32
PUBLIC __divslong

EXTERN l_divs_32_32x32

; 32-bit signed division (xcc sdcccall(1) runtime ABI). See __divulong for
; the bank-shuffle rationale — signed differs only in the underlying core.

__sdiv32:
__divslong:
   push ix
   ld ix,0
   add ix,sp

   ex de,hl
   exx

   ld l,(ix+4)
   ld h,(ix+5)
   ld e,(ix+6)
   ld d,(ix+7)

   call l_divs_32_32x32

   ex de,hl
   push hl
   push de
   exx
   pop de
   pop hl

   pop ix
   ret
