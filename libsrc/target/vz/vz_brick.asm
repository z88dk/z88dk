; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_brick
PUBLIC _vz_brick
EXTERN asm_vz_brick

.vz_brick
._vz_brick

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp asm_vz_brick
