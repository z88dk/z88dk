; uchar sp1_ScreenAttr(uchar row, uchar col)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ScreenAttr

EXTERN asm_sp1_ScreenAttr

sp1_ScreenAttr:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   
   jp asm_sp1_ScreenAttr
