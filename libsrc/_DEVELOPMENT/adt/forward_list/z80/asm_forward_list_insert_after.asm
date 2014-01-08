
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *forward_list_insert_after(void *list_item, void *item)
;
; The address of the item's forward pointer is passed as param.
;
; Insert item into list after the list_item, return item.
;
; ===============================================================

XLIB asm_forward_list_insert_after
XDEF asm_forward_list_push_front, __list_insert_next_pointers

asm_forward_list_insert_after:
asm_forward_list_push_front:
__list_insert_next_pointers:

   ; enter : hl = void *list_item (insert after this item)
   ;         de = void *item (item to be added to list)
   ;
   ; exit  : hl = void *item
   ;         de = void *list_item
   ;         z flag set if item is new end of list
   ;
   ; uses  : af, de, hl
   
   ldi
   inc bc                      ; undo changes to bc
   ld a,(hl)
   ld (de),a                   ; item->next = list_item->next

   dec de                      ; de = item
   ld (hl),d
   dec hl                      ; hl = list_item
   or (hl)                     ; z flag set if item is end of list
   ld (hl),e                   ; list_item->next = item
   
   ex de,hl                    ; hl = void *item, de = void *list_item
   ret
