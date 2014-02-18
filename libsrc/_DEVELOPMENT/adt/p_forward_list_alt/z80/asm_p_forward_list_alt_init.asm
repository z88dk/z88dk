
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_alt_init(void *p)
;
; Create an empty forward_list_ext in the four bytes of memory
; provided.
;
; ===============================================================

XLIB asm_p_forward_list_alt_init
XDEF asm_p_forward_list_alt_clear
XDEF asm_p_queue_init, asm_p_queue_clear

LIB asm_p_forward_list_init

asm_p_forward_list_alt_init:
asm_p_forward_list_alt_clear:
asm_p_queue_init:
asm_p_queue_clear:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 4
   ;         de = void *p = p_forward_list_alt_t *list
   ;
   ; uses  : af, de, hl
   
   call asm_p_forward_list_init
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; p_forward_list_alt->tail = & p_forward_list_alt->head
   inc hl
   
   ret
