
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_push_front(forward_list *list, void *item)
;
; The address of the item's forward pointer is passed as param.
;
; Add item to the front of the list.
;
; ===============================================================

XLIB asm_forward_list_push_front

LIB asm_forward_list_insert_after

asm_forward_list_push_front:

   ; enter : hl = forward_list *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = forward_list *list
   ;         z flag set if new item is only one in list
   ;
   ; uses  : af, de, hl
   
   jp asm_forward_list_insert_after
