
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *p_queue_pop(p_queue_t *q)
;
; Pop item from queue.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC asm_p_queue_pop

EXTERN asm_p_forward_list_alt_pop_front

defc asm_p_queue_pop = asm_p_forward_list_alt_pop_front

   ; enter : hl = p_queue_t *q
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item removed)
   ;            z flag set if queue is now empty
   ;            carry reset
   ;
   ;         fail if the list is empty
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
