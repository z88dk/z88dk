
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_insert(list *list, void *list_item, void *item)
;
; The address of the item's next pointer is passed as param.
;
; Insert item before list_item, which is already in the list.
;
; ===============================================================

XLIB asm_list_insert

LIB asm_list_insert_after, asm_list_push_front

asm_list_insert:

   ; enter : bc = list *list
   ;         hl = void *list_item
   ;         de = void *item
   ;
   ; exit  : bc = list *list
   ;         hl = void *item
   ; 
   ; uses  : af, de, hl

   inc hl
   inc hl                      ; hl = & list_item->prev
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   
   dec hl
   dec hl                      ; hl = & list_item_prev
   
   jp nz, asm_list_insert_after
   
   ; no previous item means adding to the front of the list
   
   ld l,c
   ld h,b
   
   jp asm_list_push_front
