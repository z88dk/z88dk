
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_push_back(list *list, void *item)
;
; The address of the item's next pointer is passed as param.
;
; Add item to the back of the list.
;
; ===============================================================

XLIB asm_list_push_back

LIB asm_forward_list_push_front, asm_forward_list_insert_after

asm_list_push_back:

   ; enter : hl = list *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         z flag set item is sole occupant of list
   ;
   ; uses  : af, de, hl

   inc de
   inc de                      ; de = & item->prev
   
   inc hl
   inc hl                      ; hl = & list->tail
   
   call asm_forward_list_push_front
   
   ; hl = & item->prev
   ; de = & list->prev
   ; z flag set if list was empty
   
   jr z, list_empty
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl

list_empty:

   dec de
   dec de
   
   dec hl
   dec hl
   
   ex de,hl
   
   ; de = & item->next
   ; hl = & item_prev->next
   
   jp asm_forward_list_insert_after
