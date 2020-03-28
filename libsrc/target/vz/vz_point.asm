; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_point
PUBLIC _vz_point
PUBLIC cpoint
PUBLIC _cpoint
EXTERN vz_point_callee
EXTERN ASMDISP_VZ_POINT_CALLEE

.vz_point
._vz_point
.cpoint
._cpoint

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   ld h,e

   jp vz_point_callee + ASMDISP_VZ_POINT_CALLEE
