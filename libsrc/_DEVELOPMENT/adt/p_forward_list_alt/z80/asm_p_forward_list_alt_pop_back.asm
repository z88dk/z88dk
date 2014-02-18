
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_pop_back(p_forward_list_alt_t *list)
;
; Pop the item from the back of the list.  O(n).
;
; ===============================================================

XLIB asm_p_forward_list_alt_pop_back

LIB asm_p_forward_list_alt_remove_after, __p_forward_list_locate_item

asm_p_forward_list_alt_pop_back:

   ; enter : hl = p_forward_list_alt_t *list
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         hl = void *item (item popped, 0 if none)
   ;         carry reset if list is empty
   ;
   ; uses  : af, bc, de, hl
   
   push hl                     ; save list

   ld bc,0                     ; locate end of list
   call __p_forward_list_locate_item
   
   pop bc                      ; bc = list
   
   ex de,hl
   jp asm_p_forward_list_alt_remove_after
