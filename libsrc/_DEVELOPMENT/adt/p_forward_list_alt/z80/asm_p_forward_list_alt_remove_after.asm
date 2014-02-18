
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_remove_after(p_forward_list_alt_t *list, void *list_item)
;
; Remove item following list_item in the list, return removed item.
;
; ===============================================================

XLIB asm_p_forward_list_alt_remove_after

LIB asm_p_forward_list_remove_after

asm_p_forward_list_alt_remove_after:

   ; enter : bc = p_forward_list_alt_t *list
   ;         hl = void *list_item (remove item after this one)
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         hl = void *item (item removed, 0 if none)
   ;         de = void *list_item
   ;         carry reset if no next item to remove (hl=0)
   ;
   ; uses  : af, de, hl
   
   call asm_p_forward_list_remove_after
   ret nc                      ; if list is empty
   ret nz                      ; if item removed was not tail
   
   ; erased item was tail
   
   inc bc
   inc bc
   
   ld a,e
   ld (bc),a
   inc bc
   ld a,d
   ld (bc),a                   ; list->tail = list_item
   
   dec bc
   dec bc
   dec bc
   
   ret
