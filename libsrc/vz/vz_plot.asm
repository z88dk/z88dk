; CALLER LINKAGE FOR FUNCTION POINTERS

PUBLIC vz_plot
EXTERN vz_plot_callee
EXTERN ASMDISP_VZ_PLOT_CALLEE

.vz_plot

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   ld h,e

   jp vz_plot_callee + ASMDISP_VZ_PLOT_CALLEE
