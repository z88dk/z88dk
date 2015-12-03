
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_alt_push_front(p_forward_list_alt_t *list, void *item)
;
; Add item to the front of the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_push_front

EXTERN asm_p_forward_list_alt_insert_after

asm_p_forward_list_alt_push_front:

   ; enter : bc = p_forward_list_alt_t *lst
   ;         de = void *item
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         hl = void *item
   ;         z flag set if item is the only one in the list
   ;
   ; uses  : af, de, hl
   
   ld l,c
   ld h,b
   
   jp asm_p_forward_list_alt_insert_after
