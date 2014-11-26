; void sp1_Initialize(uchar iflag, uchar colour, uchar tile)

SECTION seg_code_sp1

PUBLIC _sp1_Initialize

_sp1_Initialize:

   ld hl,2
   add hl,sp
   
   ld a,(hl)
   inc hl
   inc hl
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   ex de,hl

   INCLUDE "temp/sp1/zx/updater/asm_sp1_Initialize.asm"
