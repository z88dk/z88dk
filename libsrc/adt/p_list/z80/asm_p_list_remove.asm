
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_remove(p_list_t *list, void *item)
;
; Remove item from the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_remove

asm_p_list_remove:

   ; enter : bc = p_list_t *list
   ;         hl = void *item
   ;
   ; exit  : bc = p_list_t *list
   ;         hl = void *item
   ;         carry reset
   ;
   ; uses  : af, de
   
   push hl                     ; save item
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = item_next
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = item_prev->prev
   
   or h
   jr z, item_at_front

   dec hl
   dec hl

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
   ld (hl),d                   ; p_list->head = item_next
   
   ld hl,0
   jr rejoin_0

item_at_end:

   ld a,h
   or l
   jr z, no_adj
   
   dec hl
   dec hl

no_adj:

   ex de,hl
   
   ld l,c
   ld h,b
   
   inc hl
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   pop hl
   ret
