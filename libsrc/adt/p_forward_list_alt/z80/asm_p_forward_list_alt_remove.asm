
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_forward_list_alt_remove(p_forward_list_alt_t *list, void *item)
;
; Remove item from the list.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_remove

EXTERN error_zc
EXTERN __p_forward_list_locate_item, asm_p_forward_list_alt_remove_after

asm_p_forward_list_alt_remove:

   ; enter : hl = forward_list_alt_t *list
   ;         bc = void *item
   ;
   ; exit  : bc = forward_list_alt_t *list
   ;
   ;         success
   ;
   ;            hl = void *item (item removed)
   ;            z flag set if item was the tail member of list
   ;            carry reset
   ;
   ;         fail if item not member of the list
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
   
   push hl                     ; save list *
   
   call __p_forward_list_locate_item
   
   pop bc                      ; bc = list *
   jp nc, asm_p_forward_list_alt_remove_after

   jp error_zc
