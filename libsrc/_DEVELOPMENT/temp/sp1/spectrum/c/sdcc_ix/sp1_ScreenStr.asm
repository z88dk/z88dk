; uint sp1_ScreenStr(uchar row, uchar col)

PUBLIC _sp1_ScreenStr

_sp1_ScreenStr:

   ld hl,2
   
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   
   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_ScreenStr.asm"
