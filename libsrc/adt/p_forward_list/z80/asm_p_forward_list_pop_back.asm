
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_forward_list_pop_back(p_forward_list_t *list)
;
; Pop item from the back of the list.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_pop_back

EXTERN __p_forward_list_locate_item, asm_p_forward_list_remove_after

asm_p_forward_list_pop_back:

   ; enter : hl = p_forward_list_t *list
   ;
   ; exit  : de = void *last_item (new tail of list)
   ;
   ;         success
   ;
   ;            hl = void *item (popped item)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   ld bc,0                     ; locate end of list
   call __p_forward_list_locate_item
   
   ex de,hl
   jp asm_p_forward_list_remove_after
