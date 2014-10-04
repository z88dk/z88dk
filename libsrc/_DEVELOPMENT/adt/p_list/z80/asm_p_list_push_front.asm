
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_push_front(p_list_t *list, void *item)
;
; Add item to the front of the list.
;
; ===============================================================

SECTION seg_code_p_list

PUBLIC asm_p_list_push_front

EXTERN asm_p_forward_list_push_front, asm_p_forward_list_insert_after

asm_p_list_push_front:

   ; enter : hl = p_list_t *list
   ;         de = void *item
   ;
   ; exit  : hl = void *item
   ;         z flag set if item is sole occupant of list
   ;
   ; uses  : af, de, hl

   call asm_p_forward_list_push_front

   ; hl = void *item
   ; de = list *list
   ; z flag set if list was empty

   jr z, list_empty

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl

rejoin:

   inc de
   inc de

   ex de,hl

   ; de = & item->prev
   ; hl = & item_next->prev or & list->prev

   call asm_p_forward_list_insert_after

   dec hl
   dec hl

   ret

list_empty:

   inc hl
   inc hl

   jr rejoin
