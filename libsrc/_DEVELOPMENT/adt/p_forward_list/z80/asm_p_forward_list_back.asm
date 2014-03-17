
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_forward_list_back(p_forward_list_t *list)
;
; Return item at back of list without removing it from the list.
; O(n)
;
; ===============================================================

XLIB asm_p_forward_list_back

LIB __p_forward_list_locate_item, error_znc

asm_p_forward_list_back:

   ; enter : hl = p_forward_list_t *list
   ;
   ; exit  : hl = void *item_last (item at back, 0 if list empty)
   ;         carry reset if list is empty
   ;
   ; uses  : af, bc, de, hl

   ld a,(hl)
   inc hl
   or (hl)
   
   jp z, error_znc

   dec hl
   ld bc,0                     ; locate end of list
   
   jp __p_forward_list_locate_item
