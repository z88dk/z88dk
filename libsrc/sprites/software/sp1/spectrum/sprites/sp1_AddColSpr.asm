; uint sp1_AddColSpr(struct sp1_ss *s, uchar type, int graphic, uchar plane)
; CALLER linkage for function pointers

XLIB sp1_AddColSpr

LIB sp1_AddColSpr_callee
XREF ASMDISP_SP1_ADDCOLSPR_CALLEE

.sp1_AddColSpr

   pop af
   pop de
   pop bc
   pop hl
   ld h,e
   pop ix
   push hl
   push hl
   push bc
   push de
   push af
   jp sp1_AddColSpr_callee + ASMDISP_SP1_ADDCOLSPR_CALLEE
