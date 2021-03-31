; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_point
PUBLIC _vz_point
PUBLIC cpoint
PUBLIC _cpoint
EXTERN asm_vz_point

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

   jp asm_vz_point