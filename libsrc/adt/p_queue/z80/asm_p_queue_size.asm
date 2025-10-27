
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t p_queue_size(p_queue_t *q)
;
; Return number of items in queue.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC asm_p_queue_size

EXTERN asm_p_forward_list_size

defc asm_p_queue_size = asm_p_forward_list_size

   ; enter : hl = p_queue_t *q
   ;
   ; exit  : hl = number of items in queue
   ;
   ; uses  : af, de, hl
