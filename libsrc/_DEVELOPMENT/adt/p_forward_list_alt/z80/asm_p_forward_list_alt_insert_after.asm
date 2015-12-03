
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_insert_after(p_forward_list_alt_t *list, void *list_item, void *item)
;
; Insert item after list_item in the list, return item.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_insert_after

EXTERN asm_p_forward_list_insert_after, l_dec_bc

asm_p_forward_list_alt_insert_after:

   ; enter : bc = p_forward_list_alt_t *list
   ;         hl = void *list_item (insert after this item)
   ;         de = void *item (item to be added to list)
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         hl = void *item
   ;         de = void *list_item
   ;         z flag set if item is the last item in the list
   ;
   ; uses  : af, de, hl
   
   call asm_p_forward_list_insert_after
   ret nz                      ; if new item is not new end of list
   
   ; new item is now the list's tail
   
   inc bc
   inc bc
   
   ld a,l
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a                   ; list->tail = & item
   
   jp l_dec_bc - 3
