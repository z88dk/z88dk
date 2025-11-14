
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_push_front(p_list_t *list, void *item)
;
; Add item to the front of the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_push_front

EXTERN asm_p_list_front, __p_list_empty_add

asm_p_list_push_front:

   ; enter : hl = p_list_t *list
   ;         de = void *item
   ;
   ; exit  : bc = p_list_t *list
   ;         hl = void *item
   ;
   ; uses  : af, bc, de, hl

   ld c,l
   ld b,h
   
   call asm_p_list_front
   
   ; bc = p_list_t *list
   ; hl = void *item_front
   ; de = void *item

   jp z, __p_list_empty_add

   ld a,e
   ld (bc),a
   inc bc
   ld a,d
   ld (bc),a
   dec bc

   ex de,hl
   xor a
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   dec hl
   
   ; hl = & item.prev
   ; de = & item_front
   
   inc de
   inc de
   
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   ex de,hl
   
   dec hl
   dec hl
   
   ret
