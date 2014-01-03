
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_pop_front(forward_list *list)
;
; Pop item from front of list.
;
; ===============================================================

XLIB asm_forward_list_pop_front

LIB asm_forward_list_remove_after

asm_forward_list_pop_front:

   ; enter : hl = forward_list *list
   ;
   ; exit  : hl = void *item (item popped, 0 if none)
   ;         de = forward_list *list
   ;         carry reset if list was empty
   ;
   ; uses  : af, de, hl
   
   jp asm_forward_list_remove_after
