; uint sp1_ScreenStr(uchar row, uchar col)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_ScreenStr

EXTERN asm_sp1_ScreenStr

_sp1_ScreenStr:

   ld hl,2
   
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   
   jp asm_sp1_ScreenStr
