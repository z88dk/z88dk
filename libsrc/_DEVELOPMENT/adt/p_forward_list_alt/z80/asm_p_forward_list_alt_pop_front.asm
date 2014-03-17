
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_pop_front(p_forward_list_alt_t *list)
;
; Pop item from front of list.
;
; ===============================================================

XLIB asm_p_forward_list_alt_pop_front

LIB asm_p_forward_list_alt_remove_after

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
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
   
   ld c,l
   ld b,h
   
   jp asm_p_forward_list_alt_remove_after
