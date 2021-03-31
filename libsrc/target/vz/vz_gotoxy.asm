; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_gotoxy
PUBLIC _vz_gotoxy
EXTERN asm_vz_gotoxy

.vz_gotoxy
._vz_gotoxy

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp asm_vz_gotoxy