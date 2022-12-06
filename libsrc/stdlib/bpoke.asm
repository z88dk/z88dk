; CALLER linkage for function pointers

SECTION code_clib
PUBLIC bpoke
PUBLIC _bpoke
EXTERN asm_bpoke

.bpoke
._bpoke

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_bpoke

