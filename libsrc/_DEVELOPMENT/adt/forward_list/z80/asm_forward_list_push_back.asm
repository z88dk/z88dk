
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void forward_list_push_back(forward_list *list, void *item)
;
; The address of the item's forward pointer is passed as param.
;
; Add item to the front of the list.  O(n).
;
; ===============================================================

XLIB asm_forward_list_push_back

LIB __forward_list_locate_item, asm_forward_list_insert_after

asm_forward_list_push_back:

   ; enter : hl = forward_list *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = forward_list *list
   ;         z flag set if new item is only one in list
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save item
   
   ld bc,0                     ; locate end of list
   call __forward_list_locate_item
   
   pop de
   jp asm_forward_list_insert_after
