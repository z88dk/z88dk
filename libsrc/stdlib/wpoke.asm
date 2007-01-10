; CALLER linkage for function pointers

XLIB wpoke
LIB wpoke_callee
XREF ASMDISP_WPOKE_CALLEE

.wpoke

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp wpoke_callee + ASMDISP_WPOKE_CALLEE

