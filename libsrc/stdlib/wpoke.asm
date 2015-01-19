; CALLER linkage for function pointers

PUBLIC wpoke
EXTERN wpoke_callee
EXTERN ASMDISP_WPOKE_CALLEE

.wpoke

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp wpoke_callee + ASMDISP_WPOKE_CALLEE

