; void adt_QueueDeleteS(struct adt_Queue *q, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_QueueDeleteS
PUBLIC _adt_QueueDeleteS

EXTERN asm_adt_QueueDeleteS

.adt_QueueDeleteS
._adt_QueueDeleteS

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_adt_QueueDeleteS
