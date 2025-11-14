; void __FASTCALL__ sp1_Invalidate(struct sp1_Rect *r)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_Invalidate_fastcall

EXTERN asm_sp1_Invalidate

_sp1_Invalidate_fastcall:

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   jp asm_sp1_Invalidate
