; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_score
PUBLIC _vz_score
EXTERN vz_score_callee
EXTERN ASMDISP_VZ_SCORE_CALLEE

.vz_score
._vz_score

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp vz_score_callee + ASMDISP_VZ_SCORE_CALLEE
