
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_pop_back(p_forward_list_alt_t *list)
;
; Pop the item from the back of the list.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_pop_back

EXTERN asm_p_forward_list_alt_remove_after, __p_forward_list_locate_item

asm_p_forward_list_alt_pop_back:

   ; enter : hl = p_forward_list_alt_t *list
   ;
   ; exit  : bc = p_forward_list_alt_t *list
   ;         de = void *last_item (new tail of list)
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
   
   push hl                     ; save list

   ld bc,0                     ; locate end of list
   call __p_forward_list_locate_item
   
   pop bc                      ; bc = list
   
   ex de,hl
   jp asm_p_forward_list_alt_remove_after
