
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *list_remove(list *list, void *item)
;
; The address of the item's next pointer is passed as param.
;
; Remove item from the list.
;
; ===============================================================

XLIB asm_list_remove

asm_list_remove:

   ; enter : bc = list *list
   ;         hl = void *item
   ;
   ; exit  : bc = list *list
   ;         hl = void *item
   ;
   ; uses  : af, de, hl
   
   push hl                     ; save item
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = item_next
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = item_prev
   
   or h
   jr nz, item_at_front

   ld (hl),e
   inc hl
   ld (hl),d                   ; item_prev->next = item_next
   inc hl

rejoin_0:
   
   ld a,d
   or e
   jr z, item_at_end

rejoin_1:

   inc de
   inc de
   
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; item_next->prev = & item_prev->prev
   
   pop hl
   ret

item_at_front:

   ld l,c
   ld h,b
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; list->head = item_next
   
   ld hl,0
   jr rejoin_0

item_at_end:

   ld e,c
   ld d,b
   
   jr rejoin_1
