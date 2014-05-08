; void *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)

PUBLIC _sp1_PreShiftSpr

_sp1_PreShiftSpr:

   ld hl,12
   add hl,sp
   
   ld a,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld iyl,e
   ld iyh,d
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   dec hl
   ld b,(hl)
   dec hl
   dec hl
   ld c,(hl)
   dec hl
   dec hl
   ld h,(hl)
   ld l,c

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_PreShiftSpr.asm"
