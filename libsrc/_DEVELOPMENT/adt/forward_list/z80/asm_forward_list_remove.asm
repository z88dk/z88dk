
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *forward_list_remove(forward_list *list, void *item)
;
; Remove item from the list.  O(n).
;
; ===============================================================

XLIB asm_forward_list_remove

LIB __forward_list_locate_item, asm_forward_list_remove_after

asm_forward_list_remove:

   ; enter : hl = forward_list *list
   ;         bc = void *item
   ;
   ; exit  : bc = void *item
   ;
   ;         if item found
   ;
   ;            carry set
   ;            hl = void *item
   ;
   ;         if item not found
   ;
   ;            carry reset
   ;            hl = 0
   ;
   ; uses  : af, de, hl
   
   call __forward_list_locate_item
   
   jp nc, asm_forward_list_remove_after

not_found:

   xor a
   
   ld l,a
   ld h,a

   ret
