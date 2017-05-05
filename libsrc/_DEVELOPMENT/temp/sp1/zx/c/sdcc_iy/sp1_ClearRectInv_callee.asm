; void sp1_ClearRectInv(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_ClearRectInv_callee

EXTERN asm_sp1_ClearRectInv

_sp1_ClearRectInv_callee:

   pop af
   pop hl
   pop bc
   pop de
   ld d,c
   pop bc
   push af
   
   ld a,c
   push de
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl

   push iy

   call asm_sp1_ClearRectInv

   pop iy
   ret
