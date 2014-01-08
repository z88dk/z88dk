
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *forward_list_pop_back(forward_list *list)
;
; Pop item from the back of the list.  O(n).
;
; ===============================================================

XLIB asm_forward_list_pop_back

LIB __forward_list_locate_item, asm_forward_list_remove_after

asm_forward_list_pop_back:

   ; enter : hl = forward_list *list
   ;
   ; exit  : hl = void *item (item popped, 0 if none)
   ;         de = void *last_item (might be list)
   ;         carry reset if list was empty
   ;
   ; uses  : af, bc, de, hl

   ld bc,0                     ; locate end of list
   call __forward_list_locate_item
   
   ex de,hl
   jp asm_forward_list_remove_after
