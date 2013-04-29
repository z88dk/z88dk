; CALLER linkage for function pointers

XLIB strtok_r
LIB strtok_r_callee
XREF ASMDISP_STRTOK_R_CALLEE

.strtok_r

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strtok_r_callee + ASMDISP_STRTOK_R_CALLEE

