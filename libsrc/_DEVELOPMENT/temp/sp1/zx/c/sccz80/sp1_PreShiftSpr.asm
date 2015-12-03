; void *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PreShiftSpr

EXTERN asm_sp1_PreShiftSpr

sp1_PreShiftSpr:

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push de
   pop iy
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld h,(hl)
   ld l,a
   ld a,c
   
   jp asm_sp1_PreShiftSpr
