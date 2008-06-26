; CALLER linkage for function pointers

XLIB getline

LIB getdelim_callee
XREF ASMDISP_GETDELIM_CALLEE

.getline

   pop bc
   pop ix
   pop de
   pop hl
   push hl
   push de
   push hl
   push bc
   
   ld c,13
   jp getdelim_callee + ASMDISP_GETDELIM_CALLEE
