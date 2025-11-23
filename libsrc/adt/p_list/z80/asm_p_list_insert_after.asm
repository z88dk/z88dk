
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_insert_after(p_list_t *list, void *list_item, void *item)
;
; Insert item after list_item, which is already in the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_insert_after

EXTERN asm_p_forward_list_insert_after

asm_p_list_insert_after:

   ; enter : bc = p_list_t *list
   ;         hl = void *list_item
   ;         de = void *item
   ;
   ; exit  : bc = p_list_t *list
   ;         hl = void *item
   ;
   ; uses  : af, de, hl

   call asm_p_forward_list_insert_after
   
   ; hl = item
   ; de = list_item
   
   jr z, tail_changed

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl

rejoin:

   inc de
   inc de
   
   ex de,hl
   
   ; de = & item->prev
   ; hl = & item_next->prev
   
   call asm_p_forward_list_insert_after
   
   dec hl
   dec hl                      ; hl = void *item
   
   ret

tail_changed:

   ; hl = void *item
   ; de = void *list_item
   ; bc = p_list_t *list
   
   inc bc
   inc bc
   
   ld a,l
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a

   dec bc
   dec bc
   dec bc
   
   inc hl
   inc hl
   
   inc de
   inc de
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   dec hl
   dec hl
   
   ret
