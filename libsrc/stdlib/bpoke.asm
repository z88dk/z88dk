; CALLER linkage for function pointers

SECTION code_clib
PUBLIC bpoke
PUBLIC _bpoke
PUBLIC ___bpoke
EXTERN asm_bpoke

.bpoke
._bpoke
.___bpoke

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_bpoke

