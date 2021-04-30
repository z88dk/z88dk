; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_score
PUBLIC _vz_score
EXTERN vz_score_callee
EXTERN asm_vz_score

.vz_score
._vz_score

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp asm_vz_score
