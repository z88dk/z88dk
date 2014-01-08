
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_alt_pop_back(forward_list_alt *list)
;
; Pop the item from the back of the list.  O(n).
;
; ===============================================================

XLIB asm_forward_list_alt_pop_back

LIB asm_forward_list_alt_remove_after, __forward_list_locate_item

asm_forward_list_alt_pop_back:

   ; enter : hl = forward_list_alt *list
   ;
   ; exit  : bc = forward_list_alt *list
   ;         hl = void *item (item popped, 0 if none)
   ;         carry reset if list is empty
   ;
   ; uses  : af, bc, de, hl
   
   push hl                     ; save list

   ld bc,0                     ; locate end of list
   call __forward_list_locate_item
   
   pop bc                      ; bc = list
   
   ex de,hl
   jp asm_forward_list_alt_remove_after
