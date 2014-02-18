
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void p_forward_list_push_back(p_forward_list_t *list, void *item)
;
; Add item to the back of the list.  O(n).
;
; ===============================================================

XLIB asm_p_forward_list_push_back

LIB __p_forward_list_locate_item, asm_p_forward_list_insert_after

asm_p_forward_list_push_back:

   ; enter : hl = p_forward_list_t *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = p_forward_list_t *list
   ;         z flag set if new item is only one in list
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save item
   
   ld bc,0                     ; locate end of list
   call __p_forward_list_locate_item
   
   pop de
   jp asm_p_forward_list_insert_after
