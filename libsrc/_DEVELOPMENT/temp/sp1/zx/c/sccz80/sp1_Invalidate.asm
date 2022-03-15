; void __FASTCALL__ sp1_Invalidate(struct sp1_Rect *r)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_Invalidate

EXTERN asm_sp1_Invalidate

sp1_Invalidate:

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   jp asm_sp1_Invalidate

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_Invalidate
PUBLIC _sp1_Invalidate_fastcall
defc _sp1_Invalidate = sp1_Invalidate
defc _sp1_Invalidate_fastcall = sp1_Invalidate
ENDIF

