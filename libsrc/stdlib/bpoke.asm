; CALLER linkage for function pointers

SECTION code_clib
PUBLIC bpoke
PUBLIC _bpoke
EXTERN bpoke_callee
EXTERN ASMDISP_BPOKE_CALLEE

.bpoke
._bpoke

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp bpoke_callee + ASMDISP_BPOKE_CALLEE

