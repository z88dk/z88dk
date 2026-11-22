; uchar sp1_ScreenAttr(uchar row, uchar col)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_ScreenAttr

EXTERN asm_sp1_ScreenAttr

_sp1_ScreenAttr:

   ld hl,2
   add hl,sp
   
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   
   jp asm_sp1_ScreenAttr
