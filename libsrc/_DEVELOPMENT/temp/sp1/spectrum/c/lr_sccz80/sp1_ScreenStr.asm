; uint sp1_ScreenStr(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB sp1_ScreenStr

LIB asm_sp1_ScreenStr

sp1_ScreenStr:

   ld hl,2
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   
   jp asm_sp1_ScreenStr
