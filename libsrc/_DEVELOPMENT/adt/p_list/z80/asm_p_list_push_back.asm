
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_push_back(p_list_t *list, void *item)
;
; Add item to the back of the list.
;
; ===============================================================

XLIB asm_p_list_push_back

LIB asm_p_forward_list_push_front, asm_p_forward_list_insert_after

asm_p_list_push_back:

   ; enter : hl = p_list_t *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         z flag set if item is now sole occupant of list
   ;
   ; uses  : af, de, hl

   inc de
   inc de                      ; de = & item->prev
   
   inc hl
   inc hl                      ; hl = & list->tail
   
   call asm_p_forward_list_push_front
   
   ; hl = & item->prev
   ; de = & list->tail
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
   ; hl = & item->prev->next or & list->head
   
   jp asm_p_forward_list_insert_after
