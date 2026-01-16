
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_remove_after(p_forward_list_alt_t *list, void *list_item)
;
; Remove item following list_item in the list, return removed item.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_remove_after

EXTERN asm_p_forward_list_remove_after, l_dec_bc

asm_p_forward_list_alt_remove_after:

   ; enter : bc = p_forward_list_alt_t *list
   ;         hl = void *list_item (remove item after this one)
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         de = void *list_item
   ;
   ;         success
   ;
   ;            hl = void *item (item removed)
   ;            z flag set if item was the tail member of list
   ;            carry reset
   ;
   ;         fail if there is no item following list_item
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, de, hl
   
   call asm_p_forward_list_remove_after
   ret c                       ; if list is empty
   
   ret nz                      ; if item removed was not tail
   
   ; erased item was tail
   
   inc bc
   inc bc
   
   ld a,e
   ld (bc),a
   inc bc
   ld a,d
   ld (bc),a                   ; list->tail = list_item

   jp l_dec_bc - 3
