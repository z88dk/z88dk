; CALLER linkage for function pointers

XLIB bpoke
LIB bpoke_callee
XREF ASMDISP_BPOKE_CALLEE

.bpoke

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp bpoke_callee + ASMDISP_BPOKE_CALLEE

