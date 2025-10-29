
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t wa_priority_queue_size(wa_priority_queue_t *q)
;
; Return the size of the queue in words.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wa_priority_queue

PUBLIC asm_wa_priority_queue_size

EXTERN l_readword_2_hl

defc asm_wa_priority_queue_size = l_readword_2_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = size in words
   ;
   ; uses  : a, hl
