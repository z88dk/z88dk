; void __CALLEE__ sp1_InitCharStruct_callee(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XDEF sp1_InitCharStruct_callee

sp1_InitCharStruct_callee:

   pop hl
   pop bc
   ld a,c
   ex af,af
   pop bc
   pop de
   ld a,e
   pop de
   ex (sp),hl

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_InitCharStruct.asm"
