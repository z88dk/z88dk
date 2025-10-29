
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

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_push_front

EXTERN asm_p_forward_list_insert_after

defc asm_p_forward_list_push_front = asm_p_forward_list_insert_after

   ; enter : hl = p_forward_list_t *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         de = p_forward_list_t *list
   ;         z flag set if item is the only one in list
   ;
   ; uses  : af, de, hl
