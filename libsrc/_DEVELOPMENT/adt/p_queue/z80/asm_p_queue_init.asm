
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_queue_init(void *p)
;
; Create an empty queue in the four bytes of memory provided.
;
; ===============================================================

XLIB asm_p_queue_init

LIB asm_p_forward_list_alt_init

defc asm_p_queue_init = asm_p_forward_list_alt_init

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 2
   ;         de = void *p = p_queue_t *q
   ;
   ; uses  : af, de, hl
