; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC cpoint
PUBLIC _cpoint
EXTERN cpoint_callee
EXTERN ASMDISP_CPOINT_CALLEE

.cpoint
._cpoint

   pop af
   pop hl
   pop de
   push de
   push hl
   push af

   jp cpoint_callee + ASMDISP_CPOINT_CALLEE
