
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_alt_push_front(forward_list_alt *list, void *item)
;
; The address of the item's forward pointer is passed as param.
;
; Add item to the front of the list.
;
; ===============================================================

XLIB asm_forward_list_alt_push_front

LIB asm_forward_list_alt_insert_after

asm_forward_list_alt_push_front:

   ; enter : bc = forward_list_alt *lst
   ;         de = void *item
   ;
   ; exit  : bc = forward_list_alt *list
   ;         hl = void *item
   ;         z flag set if new item is only one in list
   ;
   ; uses  : af, de, hl
   
   ld l,c
   ld h,b
   
   jp asm_forward_list_alt_insert_after
