
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t p_queue_size(p_queue_t *q)
;
; Return number of items in queue.  O(n).
;
; ===============================================================

XLIB asm_p_queue_size

LIB asm_p_forward_list_size

asm_p_queue_size:

   jp asm_p_forward_list_size

;defc asm_p_queue_size = asm_p_forward_list_size

   ; enter : hl = p_queue_t *q
   ;
   ; exit  : hl = number of items in queue
   ;
   ; uses  : af, de, hl
