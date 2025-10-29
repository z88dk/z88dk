
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t ba_priority_queue_size(ba_priority_queue_t *q)
;
; Return the size of the queue in bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC asm_ba_priority_queue_size

EXTERN l_readword_hl

defc asm_ba_priority_queue_size = l_readword_hl - 4

   ; enter : hl = priority_queue *
   ;
   ; exit  : hl = size in bytes
   ;
   ; uses  : a, hl
