
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void ba_priority_queue_destroy(ba_priority_queue_t *q)
;
; Zero the queue structure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC asm_ba_priority_queue_destroy

EXTERN l_setmem_hl

asm_ba_priority_queue_destroy:

   xor a
   jp l_setmem_hl - 16

   ; enter : hl = priority_queue *
   ;
   ; uses  : af, hl
