; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC cplot
PUBLIC _cplot
EXTERN cplot_callee
EXTERN ASMDISP_CPLOT_CALLEE

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

   jp cplot_callee + ASMDISP_CPLOT_CALLEE
