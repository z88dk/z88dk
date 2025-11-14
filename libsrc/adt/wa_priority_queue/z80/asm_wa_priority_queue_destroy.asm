
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void wa_priority_queue_destroy(wa_priority_queue_t *q)
;
; Zero the queue structure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC asm_wa_priority_queue_destroy

EXTERN asm_ba_priority_queue_destroy

defc asm_wa_priority_queue_destroy = asm_ba_priority_queue_destroy

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, hl
