; void *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PreShiftSpr

EXTERN asm_sp1_PreShiftSpr

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
   pop iy
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

   jp asm_sp1_PreShiftSpr
