; CALLER linkage for function pointers

XLIB getdelim

LIB getdelim_callee
XREF ASMDISP_GETDELIM_CALLEE

.getdelim

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push hl
   push af
   
   jp getdelim_callee + ASMDISP_GETDELIM_CALLEE
