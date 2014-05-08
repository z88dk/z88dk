; uchar sp1_ScreenAttr(uchar row, uchar col)

PUBLIC _sp1_ScreenAttr

_sp1_ScreenAttr:

   ld hl,2
   add hl,sp
   
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   
   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_ScreenAttr.asm"
