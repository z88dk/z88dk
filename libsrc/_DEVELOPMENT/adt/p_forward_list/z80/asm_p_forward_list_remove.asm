
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_forward_list_remove(p_forward_list_t *list, void *item)
;
; Remove item from the list.  O(n).
;
; ===============================================================

XLIB asm_p_forward_list_remove

LIB __p_forward_list_locate_item, asm_p_forward_list_remove_after

asm_p_forward_list_remove:

   ; enter : hl = p_forward_list_t *list
   ;         bc = void *item
   ;
   ; exit  : bc = void *item
   ;
   ;         if item found
   ;
   ;            hl = void *item
   ;            de = void *item_prev (item in list before hl)
   ;            carry set
   ;
   ;         if item not found
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ; uses  : af, de, hl
   
   call __p_forward_list_locate_item
   jp nc, asm_p_forward_list_remove_after

not_found:

   xor a
   
   ld l,a
   ld h,a

   ret
