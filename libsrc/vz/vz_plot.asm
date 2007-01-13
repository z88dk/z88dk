; CALLER LINKAGE FOR FUNCTION POINTERS

XLIB vz_plot
LIB vz_plot_callee
XREF ASMDISP_VZ_PLOT_CALLEE

.vz_plot

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af

   jp vz_plot_callee + ASMDISP_VZ_PLOT_CALLEE - 1
