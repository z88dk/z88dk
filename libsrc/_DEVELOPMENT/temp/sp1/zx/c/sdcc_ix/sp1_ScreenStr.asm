; uint sp1_ScreenStr(uchar row, uchar col)

SECTION seg_code_sp1

PUBLIC _sp1_ScreenStr

_sp1_ScreenStr:

   ld hl,2
   
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   
   INCLUDE "temp/sp1/zx/tiles/asm_sp1_ScreenStr.asm"
