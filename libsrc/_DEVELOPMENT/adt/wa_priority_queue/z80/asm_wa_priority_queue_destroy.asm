
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void wa_priority_queue_destroy(ba_priority_queue_t *q)
;
; Zero the queue structure.
;
; ===============================================================

XLIB asm_wa_priority_queue_destroy

LIB l_zerostruct8_hl

defc asm_wa_priority_queue_destroy = l_zerostruct8_hl

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, hl
