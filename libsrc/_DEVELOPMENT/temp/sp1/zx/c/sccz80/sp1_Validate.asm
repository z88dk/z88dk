; void __FASTCALL__ sp1_Validate(struct sp1_Rect *r)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_Validate

EXTERN asm_sp1_Validate

sp1_Validate:

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   jp asm_sp1_Validate
