; void __CALLEE__ sp1_PutTilesInv_callee(struct sp1_Rect *r, struct sp1_tp *src)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PutTilesInv_callee

EXTERN asm_sp1_PutTilesInv

sp1_PutTilesInv_callee:

   pop af
   pop hl
   ex (sp),hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   push af

   jp asm_sp1_PutTilesInv
