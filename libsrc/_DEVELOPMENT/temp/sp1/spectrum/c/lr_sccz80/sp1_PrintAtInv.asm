; void sp1_PrintAtInv(uchar row, uchar col, uchar colour, uint tile)
; CALLER linkage for function pointers

XLIB sp1_PrintAtInv

LIB asm_sp1_PrintAtInv

sp1_PrintAtInv:

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   
   jp asm_sp1_PrintAtInv
