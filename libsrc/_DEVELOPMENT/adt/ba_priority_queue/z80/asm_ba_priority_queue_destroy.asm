
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void ba_priority_queue_destroy(ba_priority_queue_t *q)
;
; Zero the queue structure.
;
; ===============================================================

PUBLIC asm_ba_priority_queue_destroy

EXTERN l_zerostruct8_hl

asm_ba_priority_queue_destroy:

   jp l_zerostruct8_hl

;defc asm_ba_priority_queue_destroy = l_zerostruct8_hl

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, hl
