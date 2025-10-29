
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_pop_front(p_forward_list_alt_t *list)
;
; Pop item from front of list.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC asm_p_forward_list_alt_pop_front

EXTERN asm_p_forward_list_alt_remove_after

asm_p_forward_list_alt_pop_front:

   ; enter : hl = p_forward_list_alt_t *list
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item removed)
   ;            z flag set if list is now empty
   ;            carry reset
   ;
   ;         fail if the list is empty
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
   
   ld c,l
   ld b,h
   
   jp asm_p_forward_list_alt_remove_after
