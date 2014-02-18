
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_INSERT_AFTER

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_push_front(p_forward_list_t *list, void *item)
;
; The address of the item's forward pointer is passed as param.
;
; Add item to the front of the list.
;
; ===============================================================

asm_p_forward_list_push_front:

   ; enter : hl = p_forward_list_t *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = p_forward_list_t *list
   ;         z flag set if new item is only one in list
   ;
   ; uses  : af, de, hl
