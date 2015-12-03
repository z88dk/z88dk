
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void p_queue_clear(p_queue_t *q)
;
; Clear the queue to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC asm_p_queue_clear

EXTERN asm_p_forward_list_alt_init

defc asm_p_queue_clear = asm_p_forward_list_alt_init

   ; enter : hl = p_queue_t *
   ;
   ; exit  : de = p_queue_t *
   ;
   ; uses  : af, de, hl
