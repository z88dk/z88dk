; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_brick
PUBLIC _vz_brick
EXTERN vz_brick_callee
EXTERN ASMDISP_VZ_BRICK_CALLEE

.vz_brick
._vz_brick

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp vz_brick_callee + ASMDISP_VZ_BRICK_CALLEE
