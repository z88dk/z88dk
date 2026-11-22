
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_pop_front(p_forward_list_t *list)
;
; Pop item from front of list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_pop_front

EXTERN asm_p_forward_list_remove_after

defc asm_p_forward_list_pop_front = asm_p_forward_list_remove_after

   ; enter : hl = p_forward_list_t *list
   ;
   ; exit  : de = p_forward_list_t *list
   ;
   ;         success
   ;
   ;            hl = void *item (item removed)
   ;            z flag set if list is now empty
   ;            carry reset
   ;
   ;         fail if the list is empty
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, de, hl
