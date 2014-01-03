
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_ext_push_front(forward_list_ext *list, void *item)
;
; The address of the item's forward pointer is passed as param.
;
; Add item to the front of the list.
;
; ===============================================================

XLIB asm_forward_list_ext_push_front

LIB asm_forward_list_ext_insert_after

asm_forward_list_push_front:

   ; enter : bc = forward_list_ext *lst
   ;         de = void *item
   ;
   ; exit  : bc = forward_list_ext *list
   ;         hl = void *item
   ;         z flag set if new item is only one in list
   ;
   ; uses  : af, de, hl
   
   ld l,c
   ld h,b
   
   jp asm_forward_list_ext_insert_after
