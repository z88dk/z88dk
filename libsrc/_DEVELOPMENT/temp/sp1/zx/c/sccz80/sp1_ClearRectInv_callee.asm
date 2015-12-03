; void __CALLEE__ sp1_ClearRectInv_callee(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ClearRectInv_callee

EXTERN asm_sp1_ClearRectInv

sp1_ClearRectInv_callee:

   pop af
   pop bc
   pop hl
   pop de
   ld h,e
   pop de
   push af
   
   ld a,c
   push hl
   ex de,hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl   

   jp asm_sp1_ClearRectInv
