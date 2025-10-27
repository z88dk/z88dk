
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_insert(p_list_t *list, void *list_item, void *item)
;
; Insert item before list_item, which is already in the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_insert

EXTERN asm_p_list_insert_after, asm_p_list_push_front

asm_p_list_insert:

   ; enter : bc = p_list_t *list
   ;         hl = void *list_item
   ;         de = void *item
   ;
   ; exit  : bc = p_list_t *list
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
   
   jp nz, asm_p_list_insert_after
   
   ; no previous item means adding to the front of the list
   
   ld l,c
   ld h,b
   
   jp asm_p_list_push_front
