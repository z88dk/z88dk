; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_midstr
PUBLIC _vz_midstr
EXTERN vz_midstr_callee
EXTERN ASMDISP_VZ_MIDSTR_CALLEE

.vz_midstr
._vz_midstr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp vz_midstr_callee + ASMDISP_VZ_MIDSTR_CALLEE

