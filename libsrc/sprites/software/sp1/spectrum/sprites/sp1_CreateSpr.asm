; struct sp1_ss *sp1_CreateSpr(uchar type, uchar height, int graphic, uchar plane)
; CALLER linkage for function pointers

XLIB sp1_CreateSpr

LIB sp1_CreateSpr_callee
XREF ASMDISP_SP1_CREATESPR_CALLEE

.sp1_CreateSpr

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld l,(hl)
   ex de,hl
   jp sp1_CreateSpr_callee + ASMDISP_SP1_CREATESPR_CALLEE
