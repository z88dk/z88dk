; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC cplot
PUBLIC _cplot
EXTERN asm_cplot

.cplot
._cplot

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af

   jp asm_cplot
