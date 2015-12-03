
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int p_queue_empty(p_queue_t *q)
;
; Return true (non-zero) if queue is empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_queue

PUBLIC asm_p_queue_empty

EXTERN l_testword_hl

defc asm_p_queue_empty = l_testword_hl

   ; enter : hl = p_queue_t *
   ;
   ; exit  : if queue is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if queue is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
