; CALLER linkage for function pointers

XLIB fgetpos

LIB fgetpos_callee
XREF ASMDISP_FGETPOS_CALLEE

.fgetpos

   pop de
   pop hl
   pop ix
   push hl
   push hl
   push de
   
   jp fgetpos_callee + ASMDISP_FGETPOS_CALLEE
