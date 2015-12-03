
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_queue_push(p_queue_t *q, void *item)
;
; Push item into queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC asm_p_queue_push

EXTERN asm_p_forward_list_alt_push_back

defc asm_p_queue_push = asm_p_forward_list_alt_push_back

   ; enter : bc = queue *
   ;         de = void *item
   ;
   ; exit  : bc = queue *
   ;         hl = void *item
   ;
   ; uses  : af, de, hl
