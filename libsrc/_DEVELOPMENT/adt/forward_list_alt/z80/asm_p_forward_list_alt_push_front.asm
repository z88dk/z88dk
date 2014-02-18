
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)
;
; Add item to the front of the list.
;
; ===============================================================

XLIB asm_p_forward_list_alt_push_front

LIB asm_p_forward_list_alt_insert_after

asm_p_forward_list_alt_push_front:

   ; enter : bc = p_forward_list_alt_t *lst
   ;         de = void *item
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         hl = void *item
   ;         z flag set if new item is only one in list
   ;
   ; uses  : af, de, hl
   
   ld l,c
   ld h,b
   
   jp asm_p_forward_list_alt_insert_after
