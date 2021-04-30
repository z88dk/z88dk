; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC cpoint
PUBLIC _cpoint
EXTERN asm_cpoint

.cpoint
._cpoint

   pop af
   pop hl
   pop de
   push de
   push hl
   push af

   jp asm_cpoint
