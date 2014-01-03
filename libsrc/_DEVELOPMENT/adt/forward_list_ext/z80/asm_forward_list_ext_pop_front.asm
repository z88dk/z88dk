
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_ext_pop_front(forward_list_ext *list)
;
; Pop item from front of list.
;
; ===============================================================

XLIB asm_forward_list_ext_pop_front

LIB asm_forward_list_ext_remove_after

asm_forward_list_ext_pop_front:

   ; enter : hl = forward_list_ext *list
   ;
   ; exit  : bc = forward_list_ext *list
   ;         hl = void *item (item popped, 0 if none)
   ;         carry reset if list was empty
   ;
   ; uses  : af, bc, de, hl
   
   ld c,l
   ld b,h
   
   jp asm_forward_list_ext_remove_after
