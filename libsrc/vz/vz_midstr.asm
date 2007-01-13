; CALLER LINKAGE FOR FUNCTION POINTERS

XLIB vz_midstr
LIB vz_midstr_callee
XREF ASMDISP_VZ_MIDSTR_CALLEE

.vz_midstr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp vz_midstr_callee + ASMDISP_VZ_MIDSTR_CALLEE

