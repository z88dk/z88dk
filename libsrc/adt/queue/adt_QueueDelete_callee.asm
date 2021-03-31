; void __CALLEE__ adt_QueueDelete_callee(struct adt_Queue *q, void *delete)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC adt_QueueDelete_callee
PUBLIC _adt_QueueDelete_callee
PUBLIC asm_adt_QueueDelete

EXTERN adt_QueueDeleteS_callee
EXTERN asm_adt_QueueDeleteS

EXTERN _u_free

.adt_QueueDelete_callee
._adt_QueueDelete_callee

   pop hl
   pop de
   ex (sp),hl

.asm_adt_QueueDelete

   push hl
   call asm_adt_QueueDeleteS
   pop hl
   push hl
   call _u_free                 ; free struct adt_Queue container
   pop hl
   ret

