
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_pop_front(p_forward_list_alt_t *list)
;
; Pop item from front of list.
;
; ===============================================================

XLIB asm_p_forward_list_alt_pop_front
XDEF asm_p_queue_pop

LIB asm_p_forward_list_alt_remove_after

asm_p_forward_list_alt_pop_front:
asm_p_queue_pop:

   ; enter : hl = p_forward_list_alt_t *list
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         hl = void *item (item popped, 0 if none)
   ;         carry reset if list was empty
   ;
   ; uses  : af, bc, de, hl
   
   ld c,l
   ld b,h
   
   jp asm_p_forward_list_alt_remove_after
