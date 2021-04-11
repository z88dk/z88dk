; int adt_QueuePushBack(struct adt_Queue *q, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_QueuePushBack
PUBLIC _adt_QueuePushBack

EXTERN asm_adt_QueuePushBack

.adt_QueuePushBack
._adt_QueuePushBack

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_adt_QueuePushBack
