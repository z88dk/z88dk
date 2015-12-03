
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_forward_list_remove(p_forward_list_t *list, void *item)
;
; Remove item from the list.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_remove

EXTERN error_zc
EXTERN __p_forward_list_locate_item, asm_p_forward_list_remove_after

asm_p_forward_list_remove:

   ; enter : hl = p_forward_list_t *list
   ;         bc = void *item
   ;
   ; exit  : bc = void *item
   ;
   ;         success
   ;
   ;            hl = void *item
   ;            de = void *item_prev (item in list before hl, may be list *)
   ;            z flag set if item was the last in the list
   ;            carry reset
   ;
   ;         fail if item not member of the list
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, de, hl
   
   call __p_forward_list_locate_item
   jp nc, asm_p_forward_list_remove_after

   jp error_zc
