
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_push_back(p_list_t *list, void *item)
;
; Add item to the back of the list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_push_back

EXTERN asm_p_list_back, asm_p_list_insert_after, __p_list_empty_add

asm_p_list_push_back:

   ; enter : hl = p_list_t *list
   ;         de = void *item
   ;
   ; exit  : bc = p_list_t *list
   ;         hl = void *item
   ;
   ; uses  : af, bc, de, hl

   ld c,l
   ld b,h
   
   call asm_p_list_back
   
   ; bc = p_list_t *list
   ; hl = void *item_back
   ; de = void *item

   jp nz, asm_p_list_insert_after   
   jp __p_list_empty_add
