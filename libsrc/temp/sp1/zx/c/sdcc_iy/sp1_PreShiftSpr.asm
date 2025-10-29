; void *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PreShiftSpr

EXTERN l0_sp1_PreShiftSpr_callee

_sp1_PreShiftSpr:

   ld hl,12
   add hl,sp
   
   ld a,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   pop ix
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

   jp l0_sp1_PreShiftSpr_callee
