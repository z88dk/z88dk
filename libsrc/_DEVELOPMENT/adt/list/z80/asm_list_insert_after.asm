
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_insert_after(list *list, void *list_item, void *item)
;
; The address of the item's next pointer is passed as param.
;
; Insert item after list_item, which is already in the list.
;
; ===============================================================

XLIB asm_list_insert_after

LIB asm_forward_list_insert_after

asm_list_insert_after:

   ; enter : bc = list *list
   ;         hl = void *list_item
   ;         de = void *item
   ;
   ; exit  : bc = list *list
   ;         hl = void *item
   ;
   ; uses  : af, de, hl

   call asm_forward_list_insert_after
   
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
   
   call asm_forward_list_insert_after
   
   dec hl
   dec hl                      ; hl = void *item
   
   ret

tail_changed:

   ; hl = void *item
   ; de = void *list_item
   ; bc = list *list
   
   ld e,c
   ld d,b
   
   inc de
   inc de
   
   inc hl
   inc hl

   jr rejoin
