
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_push_front(list *list, void *item)
;
; The address of the item's next pointer is passed as param.
;
; Add item to the front of the list.
;
; ===============================================================

XLIB asm_list_push_front

LIB asm_forward_list_push_front, asm_forward_list_insert_after

asm_list_push_front:

   ; enter : hl = list *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;
   ; uses  : af, de, hl

   call asm_forward_list_push_front

   ; hl = void *item
   ; de = list *list
   ; z flag set if list was empty

   jr z,list_empty

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
   dec hl

   ret

list_empty:

   inc hl
   inc hl

   jr rejoin
