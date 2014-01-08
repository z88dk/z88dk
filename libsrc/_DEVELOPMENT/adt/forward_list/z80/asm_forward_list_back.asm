
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *forward_list_back(forward_list *list)
;
; Return item at back of list without removing it from the list.
; O(n)
;
; ===============================================================

XLIB asm_forward_list_back

LIB __forward_list_locate_item

asm_forward_list_back:

   ; enter : hl = forward_list *list
   ;
   ; exit  : hl = void *item (item at back, 0 if none)
   ;         carry reset if list is empty
   ;
   ; uses  : af, bc, de, hl

   ld a,(hl)
   inc hl
   or (hl)
   
   jr z, empty_list

   dec hl
   ld bc,0                     ; locate end of list
   
   jp __forward_list_locate_item

empty_list:

   ld l,a
   ld h,a

   ret
