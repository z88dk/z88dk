; uint sp1_AddColSpr(struct sp1_ss *s, uchar type, int graphic, uchar plane)
; CALLER linkage for function pointers

PUBLIC sp1_AddColSpr

EXTERN sp1_AddColSpr_callee
EXTERN ASMDISP_SP1_ADDCOLSPR_CALLEE

.sp1_AddColSpr

   pop af
   pop hl
   ld h,l
   pop bc
   pop de
   ld l,e
   pop de
   pop ix

   push hl
   push hl
   push de
   push bc
   push hl
   push af
   jp sp1_AddColSpr_callee + ASMDISP_SP1_ADDCOLSPR_CALLEE
