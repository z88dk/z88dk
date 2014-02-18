
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_insert_after(p_list_t *list, void *list_item, void *item)
;
; Insert item after list_item, which is already in the list.
;
; ===============================================================

XLIB asm_p_list_insert_after

LIB asm_p_forward_list_insert_after

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
   
   ld e,c
   ld d,b
   
   inc hl
   inc hl

   jr rejoin
