; void __CALLEE__ sp1_ClearRect_callee(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)

SECTION seg_code_sp1

PUBLIC sp1_ClearRect_callee

sp1_ClearRect_callee:

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

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_ClearRect.asm"
