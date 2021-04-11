; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_midstr
PUBLIC _vz_midstr
EXTERN asm_vz_midstr

.vz_midstr
._vz_midstr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp asm_vz_midstr
