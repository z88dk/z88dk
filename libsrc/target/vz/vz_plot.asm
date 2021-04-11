; CALLER LINKAGE FOR FUNCTION POINTERS

SECTION code_clib
PUBLIC vz_plot
PUBLIC _vz_plot
PUBLIC cplot
PUBLIC _cplot
EXTERN asm_vz_plot

.vz_plot
._vz_plot
.cplot
._cplot

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   ld h,e

   jp asm_vz_plot
