; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_sound
PUBLIC _vz_sound
EXTERN asm_vz_sound

.vz_sound
._vz_sound

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp asm_vz_sound

