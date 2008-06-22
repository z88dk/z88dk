; CALLER linkage for function pointers

XLIB fseek

LIB fseek_callee
XREF ASMDISP_FSEEK_CALLEE

.fseek

   pop af
   pop bc
   ld b,c
   pop hl
   pop de
   pop ix
   push de
   push de
   push hl
   push bc
   push af
   
   jp fseek_callee + ASMDISP_FSEEK_CALLEE
