
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_remove_after(void *list_item)
;
; Remove item following list_item in the list, return removed item.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_remove_after

EXTERN error_zc

asm_p_forward_list_remove_after:

   ; enter : hl = void *list_item (remove item after this one)
   ;
   ; exit  : de = void *list_item
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
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl
   
   ex de,hl                    ; de = void *list_item, hl = void *item
   
   ld a,h
   or l
   jp z, error_zc              ; if there is no following item
   
   ldi
   inc bc                      ; undo changes to bc
   ld a,(hl)
   ld (de),a                   ; list_item->next = item->next
   
   dec de
   dec hl
   
   ; de = void *list_item
   ; hl = void *item
   
   or (hl)                     ; tail change indicator for asm_p_forward_list_ext_*
   ret
