
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_queue_push(p_queue_t *q, void *item)
;
; Push item into queue.
;
; ===============================================================

XLIB asm_p_queue_push

LIB asm_p_forward_list_alt_push_back

asm_p_queue_push:

   jp asm_p_forward_list_alt_push_back

;defc asm_p_queue_push = asm_p_forward_list_alt_push_back

   ; enter : bc = queue *
   ;         de = void *item
   ;
   ; exit  : bc = queue *
   ;         hl = void *item
   ;
   ; uses  : af, de, hl
