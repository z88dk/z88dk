
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void p_forward_list_push_back(p_forward_list_t *list, void *item)
;
; Add item to the back of the list.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_push_back

EXTERN __p_forward_list_locate_item, asm_p_forward_list_insert_after

asm_p_forward_list_push_back:

   ; enter : hl = p_forward_list_t *list
   ;         de = void *item
   ;
   ; exit  : de = void *item_last (list_item prior to item, may be list *)
   ;         hl = void *item
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save item
   
   ld bc,0                     ; locate end of list
   call __p_forward_list_locate_item
   
   pop de
   jp asm_p_forward_list_insert_after
