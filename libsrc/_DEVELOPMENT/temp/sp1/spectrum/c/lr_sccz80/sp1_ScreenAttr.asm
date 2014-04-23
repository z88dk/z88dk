; uchar sp1_ScreenAttr(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB sp1_ScreenAttr

LIB asm_sp1_ScreenAttr

sp1_ScreenAttr:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   
   jp asm_sp1_ScreenAttr
