; CALLER LINKAGE FOR FUNCTION POINTERS

XLIB vz_gotoxy
LIB vz_gotoxy_callee
XREF ASMDISP_VZ_GOTOXY_CALLEE

.vz_gotoxy

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp vz_gotoxy_callee + ASMDISP_VZ_GOTOXY_CALLEE
